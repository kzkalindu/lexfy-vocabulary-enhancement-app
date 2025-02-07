// import 'package:flutter/material.dart';
// import 'presentation/authentication/login/login_page.dart';
//
// void main() {
//   runApp(LexfyApp());
// }
//
// class LexfyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Lexfy',
//       theme: ThemeData(
//         primaryColor: Color(0xFF636AE8), // Your main color
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: TextTheme(
//           bodyMedium: TextStyle(color: Colors.black87),
//         ),
//       ),
//       home: LoginScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '/presentation/Others/Splash.dart';
import '/presentation/authentication/login/login_page.dart';
import '/presentation/authentication/signup/signup.dart';
//import 'screens/get_started_screen.dart';
import '/presentation/home/home_page.dart';
//import 'screens/ai_coach_screen.dart';
//import 'screens/daily_challenge_screen.dart';
//import 'screens/quizzes_screen.dart';
//import 'screens/profile_screen.dart';

void main() {
  runApp(const LexfyApp());
}

class LexfyApp extends StatelessWidget {
  const LexfyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF636AE8),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        //'/get-started': (context) => GetStartedScreen(),
        '/home': (context) => const LexfyHomePage(),
        //'/ai-coach': (context) => const AICoachScreen(),
        //'/daily-challenge': (context) => const DailyChallengeScreen(),
        //'/quizzes': (context) => const QuizzesScreen(),
        //'/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

// Main Navigation
class LexfyHomePage extends StatefulWidget {
  const LexfyHomePage({Key? key}) : super(key: key);

  @override
  _LexfyHomePageState createState() => _LexfyHomePageState();
}

class _LexfyHomePageState extends State<LexfyHomePage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    //const AICoachScreen(),
   // const DailyChallengeScreen(),
   // const QuizzesScreen(),
   // const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/image.png',
              height: 40, // Increased height for better visibility
            ),
            const Text(
              'Lexfy',
              style: TextStyle(
                color: Color(0xFF636AE8),
                fontWeight: FontWeight.bold,
                fontSize: 30, // Adjusted font size for better balance
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0), // Adjusted padding for better layout
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF636AE8),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "AI Coach",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            label: "Daily Challenge",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
