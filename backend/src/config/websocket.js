import { WebSocketServer } from 'ws';
import { SpeechClient } from '@google-cloud/speech';
import { TextToSpeechClient } from '@google-cloud/text-to-speech';
import { streamAIResponse, handleUserSpeech } from '../controllers/aiController.js';
import { conversationManager } from '../controllers/conversationController.js';
import db from './firestore.js'; // Update to use Firestore

const client = new SpeechClient({
  keyFilename: process.env.SDGP_Final_STT,
});
const ttsClient = new TextToSpeechClient({
  keyFilename: process.env.SDGP_Final_TTS,
});

const requestConfig = {
  config: {
    encoding: "LINEAR16",
    sampleRateHertz: 16000,
    languageCode: "en-US",
  },
  interimResults: true,
};

const dummyUserId = "testUser123";
let currentTopic = null;
let roleDescription = "a helpful assistant";

export function initializeWebSocketServer(server) {
  const wss = new WebSocketServer({ server });

  wss.on("connection", (ws) => {
    console.log("🔗 New WebSocket Connection Established");
    let recognizeStream = null;

    ws.on("message", async (message) => {
      try {
        const data = JSON.parse(message);

        if (data.event === "setTopic") {
          const newTopic = data.topic;

          if (currentTopic !== newTopic) { // Only reset if the topic is different
              currentTopic = newTopic;
              console.log(`📌 Topic Selected: ${currentTopic}`);

              try {
                const topicsSnapshot = await db.collection('topics').where('name', '==', currentTopic).get();
                if (!topicsSnapshot.empty) {
                  const topicDoc = topicsSnapshot.docs[0];
                  roleDescription = topicDoc.data().role_description;
                  console.log(`🎭 AI Role Updated: ${roleDescription}`);

                  conversationManager.initializeConversation(dummyUserId, roleDescription);
                } else {
                  console.warn("⚠️ No matching topic found in Firestore.");
                }
              } catch (error) {
                console.error("❌ Firestore Error:", error);
              }
          }
        }

        if (data.event === "start") {
          console.log("🎤 Starting Speech Recognition...");
          recognizeStream = client.streamingRecognize(requestConfig)
            .on("error", (error) => {
              console.error("❌ Google Speech Error:", error);
              if (recognizeStream) {
                recognizeStream.destroy();
              }
              recognizeStream = null;
            })
            .on("data", (response) => {
              if (response.results[0]?.isFinal) {
                const transcript = response.results[0].alternatives[0]?.transcript;
                if (transcript) {
                  handleUserSpeech(ws, transcript, currentTopic);
                }
              }
            });
        }

        if (data.event === "audio" && data.audio) {
          const audioChunk = Buffer.from(data.audio, "base64");
          if (recognizeStream && !recognizeStream.destroyed) {
            recognizeStream.write(audioChunk);
          } else {
            console.warn("⚠️ Audio received, but no active recognizeStream.");
          }
        }

        if (data.event === "stop") {
          console.log("🛑 Stopping Speech Recognition...");
          if (recognizeStream) {
            recognizeStream.end();
            recognizeStream = null;
          }
          conversationManager.resetConversation(dummyUserId);
        }

      } catch (error) {
        console.error("❌ Error processing message:", error);
      }
    });

    ws.on("close", () => {
      console.log("❌ WebSocket Disconnected");
      if (recognizeStream) {
        recognizeStream.end();
        recognizeStream = null;
      }
      conversationManager.resetConversation(dummyUserId);
    });

    ws.on("error", (error) => {
      console.error("❌ WebSocket Error:", error);
    });
  });
}