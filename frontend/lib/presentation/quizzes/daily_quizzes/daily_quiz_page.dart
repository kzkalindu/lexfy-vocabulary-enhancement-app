import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DailyChallengeScreen extends StatefulWidget {
  @override
  _DailyChallengeScreenState createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  String selectedOption = "";
  int streakDays = 0;
  Map<String, dynamic>? currentQuestion;
  bool isAnsweredToday = false;
  DateTime? lastAnswerDate;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStreakData();
    _fetchDailyQuestion();
  }

  Future<void> _loadStreakData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      streakDays = prefs.getInt('streakDays') ?? 0;
      String? lastDateStr = prefs.getString('lastAnswerDate');
      if (lastDateStr != null) {
        lastAnswerDate = DateTime.parse(lastDateStr);
        _checkStreakReset();
        isAnsweredToday = _isSameDay(lastAnswerDate!, DateTime.now());
      }
    });
  }

  void _checkStreakReset() {
    DateTime now = DateTime.now();
    if (lastAnswerDate != null && now.difference(lastAnswerDate!).inDays > 1) {
      _resetStreak();
    }
  }

  Future<void> _resetStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      streakDays = 0;
    });
    await prefs.setInt('streakDays', 0);
  }

  Future<void> _updateStreak(bool isCorrect) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();

    if (lastAnswerDate == null || !_isSameDay(lastAnswerDate!, now)) {
      if (isCorrect) {
        if (lastAnswerDate == null) {
          streakDays = 1;
        } else if (now.difference(lastAnswerDate!).inDays == 1) {
          streakDays++;
        } else if (now.difference(lastAnswerDate!).inDays > 1) {
          streakDays = 1;
        }
      } else if (lastAnswerDate != null && now.difference(lastAnswerDate!).inDays > 1) {
        streakDays = 0;
      }

      await prefs.setInt('streakDays', streakDays);
      await prefs.setString('lastAnswerDate', now.toIso8601String());
      setState(() {
        isAnsweredToday = true;
        lastAnswerDate = now;
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _fetchDailyQuestion() async {
    if (isAnsweredToday) return;

    try {
      final firestore = FirebaseFirestore.instance;
      final questionsRef = firestore.collection('streakQuestions');

      final snapshot = await questionsRef.get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          errorMessage = 'No questions available';
        });
        return;
      }

      final dayOfMonth = DateTime.now().day;
      final questionIndex = (dayOfMonth - 1) % snapshot.docs.length;
      final questionDoc = snapshot.docs[questionIndex];

      setState(() {
        currentQuestion = {
          'question': questionDoc['question'],
          'answers': List<String>.from(questionDoc['answers']),
          'correctAnswer': questionDoc['correct_answer'],
        };
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching question: $e';
        if (e is FirebaseException && e.code == 'permission-denied') {
          errorMessage = 'Permission denied. Please check Firestore security rules.';
        }
      });
    }
  }

  void selectOption(String option) {
    if (isAnsweredToday) return;

    setState(() {
      selectedOption = option;
    });
  }

  void _checkAnswer() {
    if (selectedOption.isEmpty || isAnsweredToday) return;

    bool isCorrect = selectedOption == currentQuestion!['correctAnswer'];
    _updateStreak(isCorrect);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect
            ? 'Correct!'
            : 'Wrong! The correct answer was ${currentQuestion!['correctAnswer']}'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lexfy',
            style: TextStyle(
                color: Colors.indigo,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigo.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daily Streak',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.white),
                      SizedBox(width: 5),
                      Text('$streakDays Days',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text('Daily Challenge:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Center(
              child: errorMessage != null
                  ? Text(
                errorMessage!,
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              )
                  : Text(
                currentQuestion != null
                    ? currentQuestion!['question']
                    : 'Loading...',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            if (currentQuestion != null && errorMessage == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (currentQuestion!['answers'] as List<String>)
                    .map((option) => OptionTile(
                  text: option,
                  isSelected: selectedOption == option,
                  onTap: selectOption,
                ))
                    .toList(),
              ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: isAnsweredToday || errorMessage != null
                    ? null
                    : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                ),
                child: Text(
                  isAnsweredToday ? 'Done for Today' : 'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function(String) onTap;

  OptionTile({required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.indigo.shade300 : Colors.grey.shade200,
            border: Border.all(
              color: isSelected ? Colors.indigo : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}