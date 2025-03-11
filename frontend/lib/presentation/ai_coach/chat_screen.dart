import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';


class ChatScreen extends StatefulWidget {
  final String topic;

  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();
  late final AudioRecorder _audioRecorder;

  // Replace with your computer's IP address
  final String baseUrl = 'http://10.0.2.2:5001';
  final String baseUrlPhone = 'http://172.20.10.11:5001';// Update this!

  bool isLoading = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _requestPermissions();
    _fetchInitialAIResponse();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Microphone permission is required")),
          );
        }
      }
    } catch (e) {
      print("Error checking permissions: $e");
    }
  }

  Future<void> _fetchInitialAIResponse() async {
    await getAIResponse("Hi!");
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav'; // Changed to .wav

        final config = RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,// Changed to WAV format
          sampleRate: 44100, // Recommended for speech recognition
          numChannels: 1,
          // Mono audio
        );

        await _audioRecorder.start(config, path: filePath);
        setState(() => isRecording = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Microphone permission is required")),
          );
        }
      }
    } catch (e) {
      print("Error starting recording: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to start recording: $e")),
        );
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => isRecording = false);

      if (path != null) {
        setState(() => isLoading = true);
        String transcribedText = await sendAudioToBackend(path);
        if (transcribedText.isNotEmpty) {
          print("✅ Sending to AI: $transcribedText");
          await getAIResponse(transcribedText);
        }
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error stopping recording: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to stop recording: $e")),
        );
      }
    }
  }

  Future<String> sendAudioToBackend(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print("Audio file not found: $filePath");
        return "";
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/speech-to-text'),
      );

      // Set the content type explicitly to audio/wav
      request.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          filePath,
          contentType: MediaType('audio', 'wav'), // Explicitly set MIME type
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("✅ Backend Response: ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["text"] ?? "";
      } else {
        print("Error response: ${response.body}");
        throw Exception("Failed to transcribe audio: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending audio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to process audio: $e")),
        );
      }
      return "";
    }
  }

  Future<void> getAIResponse(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "text": userMessage});
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userMessage": userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data["aiMessage"];

        setState(() {
          messages.add({"role": "ai", "text": aiResponse});
          isLoading = false;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        throw Exception("Failed to get AI response: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting AI response: $e");
      setState(() {
        messages.add({"role": "ai", "text": "Error: Failed to get response"});
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.topic,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message["role"] == "user";
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                            child: ImageIcon(AssetImage('frontend/assets/icons/ai/ai_icon.png'), color: Colors.black),
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Color(0xFF636AE8): Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft:
                              isUser ? const Radius.circular(12) : Radius.zero,
                              bottomRight:
                              isUser ? Radius.zero : const Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isUser)
                        const CircleAvatar(
                          backgroundColor: Color(0xFF636AE8),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Tap and Hold to Speak",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onLongPress: startRecording,
                  onLongPressEnd: (_) => stopRecording(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Color(0xFF636AE8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}