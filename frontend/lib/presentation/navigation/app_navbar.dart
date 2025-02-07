import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: Key('bottomNavBar'),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Talk with Lexfy"),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: "Learnings"),
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quizzes"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
