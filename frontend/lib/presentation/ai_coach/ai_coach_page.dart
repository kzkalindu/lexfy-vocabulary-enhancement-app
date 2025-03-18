import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'chat_screen.dart';

class AiCoachScreenChooseTopic extends StatefulWidget {
  const AiCoachScreenChooseTopic({super.key});

  @override
  _AiCoachScreenChooseTopicState createState() =>
      _AiCoachScreenChooseTopicState();
}

class _AiCoachScreenChooseTopicState extends State<AiCoachScreenChooseTopic> {
  int? _selectedIndex;
  List<Map<String, dynamic>> topics = [];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  // ✅ Fetch topics from backend
  Future<void> _fetchTopics() async {
    try {
      const String backendUrl = "http://172.20.10.6:5000/api/topics"; // Change IP if needed
      final response = await http.get(Uri.parse(backendUrl));

      if (response.statusCode == 200) {
        setState(() {
          topics = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        print("❌ Failed to load topics");
      }
    } catch (e) {
      print("❌ Error fetching topics: $e");
    }
  }

  void _selectRandomTopic() {
    if (topics.isNotEmpty) {
      setState(() {
        _selectedIndex = (topics..shuffle()).indexOf(topics.first);
      });

      _navigateToChat(topics[_selectedIndex!]["name"]);
    }
  }

  void _navigateToChat(String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(topic: topic),
      ),
    );
  }

  Widget _buildTopicCard({
    required String title,
    required String iconPath,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;
    Color textColor = isSelected ? Colors.white : const Color(0xFF636AE8);
    Color iconColor = isSelected ? Colors.white : const Color(0xFF636AE8);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF636AE8) : const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    height: constraints.maxHeight * 0.25,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: constraints.maxHeight * 0.12,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
        title: const Text(
          'Talk with Lexfy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: constraints.maxHeight * 0.04),
                const Text(
                  'Select a Topic',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a topic to start a conversation with\nyour AI coach.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: constraints.maxHeight * 0.02),

                // Grid of topics
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: topics.isEmpty
                        ? const Center(child: CircularProgressIndicator()) // ✅ Show loading spinner
                        : GridView.builder(
                      itemCount: topics.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: constraints.maxWidth /
                            (constraints.maxHeight * 0.5),
                      ),
                      itemBuilder: (context, index) {
                        return _buildTopicCard(
                          title: topics[index]["name"],
                          iconPath: topics[index]["icon_svg"],
                          index: index,
                        );
                      },
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    children: [
                      // Random Topic Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: topics.isNotEmpty ? _selectRandomTopic : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF636AE8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Random',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF636AE8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Choose Topic Button (Enabled only if a topic is selected)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedIndex != null
                              ? () => _navigateToChat(topics[_selectedIndex!]["name"])
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedIndex != null
                                ? const Color(0xFF636AE8)
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Choose',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
