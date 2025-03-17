import 'package:flutter/material.dart';
import '/presentation/quizzes/all_quizzes/quiz_page.dart';
import '/presentation/quizzes/daily_quizzes/daily_quiz_page.dart';
import '/presentation/Learning/learning_page.dart';

class SelectTaskPage extends StatelessWidget {
  const SelectTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Word Challenge Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Daily Word Challenge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Your Daily Streak: 0 Days'),
                      ],
                    ),
                    // Right Section (Continue button)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailyChallengeScreen(),
                          ),
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quizzes Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Quizzes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Current Level: 0'),
                      ],
                    ),
                    // Right Section (Continue button)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizPage(),
                          ),
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Footer: "Want to learn more? Go to Learning"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Want to learn More?'),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LearningPage()),
                    );
                  },
                  child: const Text('Go to Learning'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
