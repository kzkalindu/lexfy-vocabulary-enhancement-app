import 'package:flutter/material.dart';
import 'chat_screen.dart';

class AiCoachScreenChooseTopic extends StatefulWidget {
  const AiCoachScreenChooseTopic({super.key});

  @override
  _AiCoachScreenChooseTopicState createState() => _AiCoachScreenChooseTopicState();
}

class _AiCoachScreenChooseTopicState extends State<AiCoachScreenChooseTopic> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> topics = [
    {"title": "Ordering Coffee", "icon": Icons.shopping_cart_outlined},
    {"title": "Booking a Flight", "icon": Icons.flight_outlined},
    {"title": "Asking for Directions", "icon": Icons.map_outlined},
    {"title": "Small Talk", "icon": Icons.chat_bubble_outline},
  ];

  void _selectRandomTopic() {
    setState(() {
      _selectedIndex = (topics..shuffle()).indexOf(topics.first);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(topic: topics[_selectedIndex!]["title"]),
      ),
    );
  }

  Widget _buildTopicCard({
    required String title,
    required IconData icon,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ?  Color(0xFF636AE8) : const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: constraints.maxHeight * 0.25, // Responsive icon size
                    color: isSelected ? Colors.white : Colors.deepPurple,
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: constraints.maxHeight * 0.12, // Responsive font size
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
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
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topics.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: constraints.maxWidth / (constraints.maxHeight * 0.5),
                      ),
                      itemBuilder: (context, index) {
                        return _buildTopicCard(
                          title: topics[index]["title"],
                          icon: topics[index]["icon"],
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
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _selectRandomTopic,
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
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedIndex != null
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    topic: topics[_selectedIndex!]["title"]),
                              ),
                            );
                          }
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
