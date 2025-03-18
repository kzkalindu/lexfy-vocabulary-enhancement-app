import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class ChatScreen extends StatefulWidget {
  final String topic;

  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  static const mainColor = Color(0xFF636AE8);

  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();
  late final AudioRecorder _audioRecorder;
  late IOWebSocketChannel _channel;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  final FlutterTts _flutterTts = FlutterTts();
  bool isRecording = false;
  bool conversationStarted = false;
  String? pendingUserMessage;
  String? currentAiResponse;
  String? _currentUserMessage;
  bool _isProcessingMessage = false;
  final List<String> _suggestedResponses = [];

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _requestPermissions();
    _connectWebSocket();
    _configureTextToSpeech();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Pulse animation for the mic button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _pulseController.forward();
      }
    });

    // Wave animation for background
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
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
    String serverIp = "172.20.10.6";
    String wsUrl = "ws://$serverIp:5000";
    print("Connecting to WebSocket: $wsUrl");

    _channel = IOWebSocketChannel.connect(wsUrl);

    // Send topic to backend
    _channel.sink.add(jsonEncode({
      "event": "setTopic",
      "topic": widget.topic,
    }));

    _channel.stream.listen((message) {
      try {
        final decodedMessage = jsonDecode(message);
        final event = decodedMessage["event"];

        if (event == "text") {
          final text = decodedMessage["text"] as String;
          final role = decodedMessage["role"] as String;
          final isComplete = decodedMessage["isComplete"] as bool;

          setState(() {
            if (role == "user") {
              if (text.trim().toLowerCase() == "hi" && !conversationStarted) {
                conversationStarted = true;
                stopRecording();
              }
              _currentUserMessage = text;

              messages.add({
                "role": "user",
                "text": text,
              });
              _suggestedResponses.clear();
            } else if (role == "ai") {
              if (messages.isNotEmpty && messages.last["role"] == "ai") {
                messages.last["text"] = text;
              } else {
                messages.add({
                  "role": "ai",
                  "text": text,
                });
              }

              if (isComplete) {
                _speakText(text);
              }
            }
          });

          _scrollToBottom();
        } else if (event == "suggestions") {
          final List<dynamic> suggestions = decodedMessage["suggestions"];
          setState(() {
            _suggestedResponses
              ..clear()
              ..addAll(suggestions.map((s) => s.toString())); // ✅ Show suggestions only after AI responds
          });
        }
        else if (event == "audio") {
          final audioBase64 = decodedMessage["audio"] as String;
          final audioBytes = base64Decode(audioBase64);
          final audioPlayer = AudioPlayer();
          audioPlayer.play(BytesSource(audioBytes));
        }
      } catch (e) {
        print("Error processing message: $e");
      }
    }, onError: (error) {
      print("WebSocket Error: $error");
      Future.delayed(const Duration(seconds: 3), _connectWebSocket);
    }, onDone: () {
      print("WebSocket closed, reconnecting...");
      Future.delayed(const Duration(seconds: 3), _connectWebSocket);
    });
  }

  Future<void> stopRecording() async {
    try {
      if (!isRecording) return;

      setState(() {
        isRecording = false;
        _isProcessingMessage = true;
        // Clear suggestions only when stopping the recording
        _suggestedResponses.clear();
      });

      await _audioRecorder.stop();
      _channel.sink.add(jsonEncode({"event": "stop"}));

      if (_currentUserMessage != null && !_isProcessingMessage) {
        setState(() {
          messages.add({
            "role": "user",
            "text": _currentUserMessage!,
          });
          _currentUserMessage = null;
          _isProcessingMessage = false;
        });
        _scrollToBottom();
      }

      print("✅ Recording stopped.");
    } catch (e) {
      print("❌ Error stopping recording: $e");
      setState(() => _isProcessingMessage = false);
    }
  }

  Future<void> _speakText(String text) async {
    final url = Uri.parse('https://172.20.10.6:3000/api/tts'); // Replace with your actual backend URL

    try {
      final response = await http.post(
        url,
        body: {'text': text},
      );

      if (response.statusCode == 200) {
        final audioPlayer = AudioPlayer();
        try {
          await audioPlayer.play(UrlSource(response.body));
        } catch (e) {
          print('Error playing audio: $e');
        }
      } else {
        print('Failed to fetch TTS audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching TTS audio: $e');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _currentUserMessage = null;
          _isProcessingMessage = false;
          // Remove this line that was clearing the suggestions
          // _suggestedResponses.clear();
        });

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
  Widget _buildSuggestedResponses() {
    if (_suggestedResponses.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Center(
            child: Text(
              "You could say:",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(
              minHeight: 60,  // Minimum height
              maxHeight: 120, // Maximum height
            ),
            child: PageView.builder(
              itemCount: _suggestedResponses.length,
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _suggestedResponses[index],
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 5, // Increased max lines
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _suggestedResponses.length,
                  (index) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainColor.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildStartScreen() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Animated background waves
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    animation: _waveController,
                    color: mainColor,
                  ),
                );
              },
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: mainColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "AI Speaking Coach",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 30,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Welcome to Your\nSpeaking Practice",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Say 'Hi' to start your conversation",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Microphone Button
                            ScaleTransition(
                              scale: _pulseAnimation,
                              child: GestureDetector(
                                onLongPress: startRecording,
                                onLongPressEnd: (_) => stopRecording(),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isRecording ? Colors.red : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isRecording ? Colors.red : mainColor).withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isRecording ? Colors.red.withOpacity(0.5) : mainColor.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.mic,
                                    color: isRecording ? Colors.white : mainColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Instructions
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: mainColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: mainColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Press and hold to speak",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatUI() {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.topic,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      if (!isUser)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn), // ✅ Apply mainColor
                            child: Image.asset(
                              'assets/icons/ai_icon.png', // ✅ AI image path
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser ? mainColor : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.2,
                              color: isUser ? Colors.white : Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (isUser)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: mainColor,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSuggestedResponses(),
                Text(
                  "Tap and Hold to Speak",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onLongPress: startRecording,
                  onLongPressEnd: (_) => stopRecording(),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? Colors.red : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? Colors.red : mainColor).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: isRecording ? Colors.red.withOpacity(0.5) : mainColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.mic,
                      color: isRecording ? Colors.white : mainColor,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: conversationStarted ? _buildChatUI() : _buildStartScreen(),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final waveCount = 3;

    for (var i = 0; i < waveCount; i++) {
      final waveOffset = animation.value * 2 * pi + (i * pi / waveCount);
      path.moveTo(0, size.height * 0.5);

      for (var x = 0.0; x <= size.width; x++) {
        final y = size.height * 0.5 +
            sin(x / size.width * 4 * pi + waveOffset) * waveHeight;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}