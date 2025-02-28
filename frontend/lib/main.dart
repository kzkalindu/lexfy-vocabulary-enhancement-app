import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/ai_coach/ai_coach_page.dart';
import 'package:frontend/presentation/quizzes/all_quizzes/quiz_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/presentation/Others/splash_page.dart';
import '/presentation/authentication/login/login_page.dart';
import '/presentation/authentication/signup/signup_page.dart';
import '/presentation/home/home_page.dart';
import '/presentation/profile/profile_page.dart';
import '/presentation/learning/learning_page.dart';
import '/presentation/profile/leaderboard_page.dart';
import '/presentation/quizzes/all_quizzes/quiz_page.dart';
import '/presentation/ai_coach/ai_coach_page.dart';
import '/presentation/ai_coach/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/home': (context) => const LexfyHomePage(),
        '/learning': (context) => YouTubeVideoScreen(),
        '/profile': (context) => ProfileScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
      },
    );
  }
}

class LexfyHomePage extends StatefulWidget {
  const LexfyHomePage({Key? key}) : super(key: key);

  @override
  _LexfyHomePageState createState() => _LexfyHomePageState();
}

class _LexfyHomePageState extends State<LexfyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AiCoachScreenChooseTopic(),
    YouTubeVideoScreen(),
    const QuizScreen(),
    ProfileScreen(),
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
              'assets/images/logos/Logo-Purple-S.png',
              height: 40,
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: _buildBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _buildBottomNavigationBar(),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: Colors.deepPurple, width: 2),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
          blurRadius: 5,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 43, 43, 43),
      type: BottomNavigationBarType.fixed,
      items: _buildBottomNavigationBarItems(),
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: widget.onIndexChanged,
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 20),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline, size: 20),
        label: 'Talk with Lexfy',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book, size: 20),
        label: 'Learnings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.quiz, size: 20),
        label: 'Quizzes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline, size: 20),
        label: 'Profile',
      ),
    ];
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), checkUserStatus);
  }

  void checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF636AE8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logos/Logo-White.png',
                  width: 220,
                  height: 220,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}