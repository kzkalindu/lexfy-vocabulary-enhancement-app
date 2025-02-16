// import 'package:flutter/material.dart';
//
// import 'app_navbar.dart';
//
// class NavigationPage extends StatefulWidget {
//   const NavigationPage({super.key});
//
//   @override
//   _NavigationPageState createState() => _NavigationPageState();
// }
//
// class _NavigationPageState extends State<NavigationPage> {
//   int _currentIndex = 0;
//
//   static const List<Widget> _pages = [
//     HomeScreen(),
//     LearningScreen(),
//     QuizzesScreen(),
//     AICoachScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//       ),
//     );
//   }
// }