import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  late IOWebSocketChannel _channel;
  final FlutterTts _flutterTts = FlutterTts();
  bool isRecording = false;
  bool conversationStarted = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _requestPermissions();
    _connectWebSocket();
    _configureTextToSpeech();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _scrollController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (!await _audioRecorder.hasPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission is required")),
      );
    }
  }

  void _configureTextToSpeech() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  void _connectWebSocket() {
    String serverIp = "192.168.68.100"; // Replace with your server IP
    String wsUrl = "ws://$serverIp:3000";
    print("Connecting to WebSocket: $wsUrl");

    _channel = IOWebSocketChannel.connect(wsUrl);

    _channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      final transcript = decodedMessage["text"];
      final role = decodedMessage["role"];

      setState(() {
        if (role == "user") {
          // Add new user message
          messages.add({"role": "user", "text": transcript});

          // Check if this is the "hi" message to start conversation
          if (transcript.trim().toLowerCase() == "hi" && !conversationStarted) {
            conversationStarted = true;
          }
        } else if (role == "ai") {
          if (messages.isNotEmpty && messages.last["role"] == "ai") {
            // Update existing AI message
            messages.last["text"] = "${messages.last["text"]}$transcript";
          } else {
            // Add new AI message
            messages.add({"role": "ai", "text": transcript});
          }

          // Speak the AI response
          _speakText(transcript);
        }
      });

      // Auto-scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }, onError: (error) {
      print("WebSocket Error: $error");
      Future.delayed(const Duration(seconds: 3), _connectWebSocket);
    }, onDone: () {
      print("WebSocket closed, reconnecting...");
      Future.delayed(const Duration(seconds: 3), _connectWebSocket);
    });
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (isRecording) {
          await stopRecording();
        }

        _channel.sink.add(jsonEncode({"event": "start"}));

        Stream<Uint8List> stream = await _audioRecorder.startStream(
          RecordConfig(encoder: AudioEncoder.pcm16bits, sampleRate: 16000, numChannels: 1),
        );

        print("🎤 Recording started. Streaming to backend...");

        stream.listen(
              (Uint8List audioData) {
            if (audioData.isNotEmpty) {
              _channel.sink.add(jsonEncode({
                "event": "audio",
                "audio": base64Encode(audioData)
              }));
            }
          },
          onError: (error) {
            print("❌ Error streaming audio: $error");
            stopRecording();
          },
          onDone: () {
            print("🎤 Audio stream finished.");
          },
        );

        setState(() => isRecording = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission is required")),
        );
      }
    } catch (e) {
      print("❌ Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      if (!isRecording) return;

      setState(() => isRecording = false);
      await _audioRecorder.stop();
      _channel.sink.add(jsonEncode({"event": "stop"}));

      print("✅ Recording stopped.");
    } catch (e) {
      print("❌ Error stopping recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: conversationStarted ? _buildChatUI() : _buildStartScreen(),
    );
  }

  Widget _buildStartScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Say Hi to Start Conversation",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onLongPress: startRecording,
                onLongPressEnd: (_) => stopRecording(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.red : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 40),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatUI() {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(widget.topic, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
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
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isUser) const ImageIcon(AssetImage('/Users/udula/StudioProjects/SDGP/lib/icons/ai_icon.png'), color: Colors.grey),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.purple[700] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message["text"] ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (isUser)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  "Tap and Hold to Speak",
                  style: TextStyle(color: Colors.grey)
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onLongPress: startRecording,
                onLongPressEnd: (_) => stopRecording(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.red : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 40),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}