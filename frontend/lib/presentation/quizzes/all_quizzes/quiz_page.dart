import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _quizCategories = [
    {
      'title': 'Grammar',
      'icon': Icons.book,
      'color': Colors.blue,
      'progress': 0.7,
    },
    {
      'title': 'Vocabulary',
      'icon': Icons.library_books,
      'color': Colors.green,
      'progress': 0.5,
    },
    {
      'title': 'Pronunciation',
      'icon': Icons.record_voice_over,
      'color': Colors.orange,
      'progress': 0.3,
    },
    {
      'title': 'Reading',
      'icon': Icons.menu_book,
      'color': Colors.purple,
      'progress': 0.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Quizzes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _quizCategories.length,
              itemBuilder: (context, index) {
                final category = _quizCategories[index];
                return InkWell(
                  onTap: () {
                    // Handle category selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${category['title']} quiz selected'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: category['color'].withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'],
                          size: 40,
                          color: category['color'],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: category['progress'],
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            category['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(category['progress'] * 100).round()}% Complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}