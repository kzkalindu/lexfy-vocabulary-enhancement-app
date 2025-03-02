import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class VocabularyApp extends StatelessWidget {
  const VocabularyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF636AE8),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF636AE8),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final String apiUrl = "http://10.0.2.2:3000/questions";
  List<dynamic> questions = [];
  bool isLoading = true;
  String errorMessage = '';
  int currentIndex = 0;
  Map<int, String> selectedAnswers = {};
  Map<int, String> correctAnswers = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          questions = data;
          isLoading = false;
          for (int i = 0; i < data.length; i++) {
            correctAnswers[i] = data[i]['correct_answer'];
          }
        });
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching questions. Check server connection.';
      });
    }
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void calculateScore() {
    int correctCount = selectedAnswers.entries.where((entry) => correctAnswers[entry.key] == entry.value).length;
    _showScoreDialog(correctCount);
  }

  void _showScoreDialog(int correctCount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text("You got $correctCount / ${questions.length} correct!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Text(errorMessage, style: const TextStyle(color: Colors.red))
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildQuestionCard(questions[currentIndex]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.lightbulb, color: Theme.of(context).primaryColor, size: 50),
        const SizedBox(height: 8),
        Text(
          "Lexfy",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    List<String> options = [
      question['option_a'],
      question['option_b'],
      question['option_c'],
      question['option_d'],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF636AE8)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            question['question_text'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: options.map((option) {
              return OptionButton(
                text: option,
                isSelected: selectedAnswers[currentIndex] == option,
                onTap: () {
                  setState(() {
                    selectedAnswers[currentIndex] = option;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0 ? previousQuestion : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: currentIndex == questions.length - 1 ? calculateScore : nextQuestion,
                child: Text(currentIndex == questions.length - 1 ? 'Submit' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({super.key, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF636AE8) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: BorderSide(color: isSelected ? Colors.white : Colors.black54),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
