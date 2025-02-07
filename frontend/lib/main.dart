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

//import 'package:flutter/material.dart';
//import '/presentation/Others/Splash.dart';
//import '/presentation/authentication/login/login_page.dart';
//import '/presentation/authentication/signup/signup.dart';
//import 'screens/get_started_screen.dart';
//import '/presentation/home/home_page.dart';
//import 'screens/ai_coach_screen.dart';
//import 'screens/daily_challenge_screen.dart';
//import 'screens/quizzes_screen.dart';
//import 'screens/profile_screen.dart';

//void main() {
//  runApp(const LexfyApp());
//}

//class LexfyApp extends StatelessWidget {
//   const LexfyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF636AE8),
//         fontFamily: 'Poppins',
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/login': (context) => LoginScreen(),
//         '/signup': (context) => SignUpScreen(),
//         //'/get-started': (context) => GetStartedScreen(),
//         '/home': (context) => const LexfyHomePage(),
//         //'/ai-coach': (context) => const AICoachScreen(),
//         //'/daily-challenge': (context) => const DailyChallengeScreen(),
//         //'/quizzes': (context) => const QuizzesScreen(),
//         //'/profile': (context) => const ProfileScreen(),
//       },
//     );
//   }
// }

// // Main Navigation
// class LexfyHomePage extends StatefulWidget {
//   const LexfyHomePage({Key? key}) : super(key: key);

//   @override
//   _LexfyHomePageState createState() => _LexfyHomePageState();
// }

// class _LexfyHomePageState extends State<LexfyHomePage> {
//   int _selectedIndex = 0;
//   final ScrollController _scrollController = ScrollController();

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     //const AICoachScreen(),
//    // const DailyChallengeScreen(),
//    // const QuizzesScreen(),
//    // const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/image.png',
//               height: 40, // Increased height for better visibility
//             ),
//             const Text(
//               'Lexfy',
//               style: TextStyle(
//                 color: Color(0xFF636AE8),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 30, // Adjusted font size for better balance
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.settings, color: Colors.black),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//             horizontal: 16.0,
//             vertical: 8.0), // Adjusted padding for better layout
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           child: _screens[_selectedIndex],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF636AE8),
//         unselectedItemColor: Colors.grey,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_bubble_outline),
//             label: "AI Coach",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.flag_outlined),
//             label: "Daily Challenge",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.quiz),
//             label: "Quiz",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            hintText: "Search for Words…",
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF636AE8)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF636AE8)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF636AE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Button 1",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF636AE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Button 2",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF636AE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Button 3",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 220, 220, 220),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Empathy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '(n.) The ability to understand and share the feelings of another',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              Text(
                'Example: She showed empathy by listening carefully and offering support to her friend who was going through a tough time.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
