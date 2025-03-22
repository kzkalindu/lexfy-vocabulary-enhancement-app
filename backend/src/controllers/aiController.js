import axios from 'axios';
import { conversationManager } from './conversationController.js';
import { TextToSpeechClient } from '@google-cloud/text-to-speech';
import db from '../config/firestore.js'; // Update to use Firestore
import dotenv from 'dotenv';

dotenv.config();

const MISTRAL_API_KEY = process.env.MISTRAL_API_KEY;
const MISTRAL_API_URL = process.env.MISTRAL_API_URL;
const ttsClient = new TextToSpeechClient({
  keyFilename: process.env.SDGP_Final_TTS,
});

const MAX_RETRIES = 3; // Define the maximum number of retries
const RETRY_DELAYS = [1000, 2000, 4000]; // Delays in milliseconds

async function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export async function textToSpeech(text, ws = null) {
  try {
    const [response] = await ttsClient.synthesizeSpeech({
      input: { text },
      voice: { languageCode: "en-US", ssmlGender: "NEUTRAL" },
      audioConfig: { audioEncoding: "MP3" },
    });

    const audioBase64 = response.audioContent.toString("base64");

    if (ws) {
      ws.send(JSON.stringify({
        event: "audio",
        audio: audioBase64,
      }));
      console.log("🔊 Sent synthesized speech to client via WebSocket.");
    } else {
      console.log("🔊 Generated synthesized speech.");
      return audioBase64;
    }
  } catch (error) {
    console.error("❌ TTS Error:", error);
    throw error;
  }
}

export async function generateSuggestedResponsesWithRetry(aiResponse, roleDescription, retryCount = 0) {
  try {
    console.log("\n📝 Generating suggested responses for AI response:", aiResponse);

    const response = await axios.post(
      MISTRAL_API_URL,
      {
        model: "mistral-tiny",
        messages: [
          {
            role: "system",
            content: `You are ${roleDescription}. Generate two brief, natural follow-up responses that a user might say to continue the conversation with you. Each response should be 1-2 sentences and conversational in tone. Format each response as '"..."' and '"..."'.`
          },
          {
            role: "user",
            content: `Based on this AI response, generate two alternative user responses:\n${aiResponse}. The both responses you generate should be responses the user can say to the person described in the role description.`
          }
        ],
        max_tokens: 100,
        temperature: 0.7,
      },
      {
        headers: {
          "Authorization": `Bearer ${MISTRAL_API_KEY}`,
          "Content-Type": "application/json",
        }
      }
    );

    const suggestions = response.data.choices[0].message.content
      .split('\n')
      .filter(line => line.trim())
      .slice(0, 2)
      .map(suggestion => {
        const match = suggestion.match(/"([^"]+)"/);
        return match ? match[1].trim() : suggestion.trim();
      });

    console.log("✅ Generated suggested responses:", suggestions);
    return suggestions;
  } catch (error) {
    if (error.response?.status === 429 && retryCount < MAX_RETRIES) {
      console.log(`⏳ Rate limit hit, retrying in ${RETRY_DELAYS[retryCount]}ms...`);
      await delay(RETRY_DELAYS[retryCount]);
      return generateSuggestedResponsesWithRetry(aiResponse, roleDescription, retryCount + 1);
    }

    console.error("❌ Error generating suggested responses:", error);
    return ["Could you explain more?", "Tell me more about that."];
  }
}

export async function streamAIResponse(ws, userMessage, currentTopic, userId) {
  console.log("\n🗣️ User:", userMessage);

  // Check if the user wants to end the conversation
  if (userMessage.toLowerCase().includes("end conversation") || userMessage.toLowerCase().includes("stop conversation")) {
    console.log("🔚 Ending conversation as requested by the user.");
    conversationManager.resetConversation(userId); // Reset the conversation for the user
    ws.send(JSON.stringify({
      event: "text",
      text: "The conversation has been ended as per your request. How can I assist you further?",
      role: "ai",
      isComplete: true,
      userUID: userId // Include userUID in the response
    }));
    ws.send(JSON.stringify({
      event: "end_conversation",
      message: "Navigating to the first screen of the AI coach part.",
      userUID: userId // Include userUID in the response
    }));
    return;
  }

  // Fetch roleDescription from Firestore based on the current topic
  let roleDescription = "a helpful assistant"; // Default role description
  try {
    const topicsSnapshot = await db.collection('topics').where('name', '==', currentTopic).get();
    if (!topicsSnapshot.empty) {
      const topicDoc = topicsSnapshot.docs[0]; // Get the first matching document
      roleDescription = topicDoc.data().role_description;
    }
  } catch (error) {
    console.error("❌ Firestore Error:", error);
  }

  conversationManager.addMessage(userId, "user", userMessage, roleDescription);

  try {
    const response = await axios.post(
      MISTRAL_API_URL,
      {
        model: "mistral-tiny",
        messages: conversationManager.getConversation(userId),
        stream: true,
        max_tokens: 150,
        temperature: 0.7,
      },
      {
        headers: {
          "Authorization": `Bearer ${MISTRAL_API_KEY}`,
          "Content-Type": "application/json",
        },
        responseType: "stream",
      }
    );

    let fullResponse = "";
    let tokenCount = 0;
    console.log("\n🤖 AI Response:");

    response.data.on("data", (chunk) => {
      const lines = chunk.toString().split("\n");

      for (const line of lines) {
        const trimmedLine = line.trim();
        if (!trimmedLine || trimmedLine === "data: [DONE]") continue;

        try {
          if (trimmedLine.startsWith("data: ")) {
            const jsonStr = trimmedLine.slice(6);
            const jsonResponse = JSON.parse(jsonStr);
            const content = jsonResponse.choices[0]?.delta?.content;

            if (content) {
              tokenCount += content.split(/\s+/).length;

              if (tokenCount <= 150) {
                fullResponse += content;
                process.stdout.write(content);
                ws.send(JSON.stringify({
                  event: "text",
                  text: fullResponse,
                  role: "ai",
                  isComplete: false,
                  userUID: userId // Include userUID in the response
                }));
              }
            }
          }
        } catch (error) {
          console.warn("⚠️ Error parsing line:", error.message);
        }
      }
    });

    response.data.on("end", async () => {
      conversationManager.addMessage(userId, "assistant", fullResponse, roleDescription);
      console.log("\n");

      const suggestedResponses = await generateSuggestedResponsesWithRetry(fullResponse, roleDescription);
      console.log("🔄 Sending suggested responses to client:", suggestedResponses);

      ws.send(JSON.stringify({
        event: "suggestions",
        suggestions: suggestedResponses,
        userUID: userId // Include userUID in the response
      }));

      ws.send(JSON.stringify({
        event: "text",
        text: fullResponse,
        role: "ai",
        isComplete: true,
        userUID: userId // Include userUID in the response
      }));

      console.log("✅ AI Streaming Complete\n");
      textToSpeech(fullResponse, ws);
    });

  } catch (error) {
    console.error("❌ AI API Error:", error.response?.data || error.message);
    ws.send(JSON.stringify({
      event: "text",
      text: "Sorry, I encountered an error while processing your request.",
      role: "ai",
      isComplete: true,
      userUID: userId // Include userUID in the response
    }));
  }
}

export async function handleUserSpeech(ws, transcript, currentTopic, userID) {
  console.log("📝 User Transcription:", transcript);
  ws.send(JSON.stringify({
    event: "text",
    text: transcript,
    role: "user",
    isComplete: true,
    userUID: userID // Include userUID in the response
  }));

  await streamAIResponse(ws, transcript, currentTopic, userID);
}