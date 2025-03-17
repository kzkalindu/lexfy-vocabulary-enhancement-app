import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:frontend/services/user_service.dart';
import '/presentation/quizzes/all_quizzes/quiz_page.dart';
import '/presentation/quizzes/daily_quizzes/daily_quiz_page.dart';
import '/presentation/Learning/learning_page.dart';

class SelectTaskPage extends StatefulWidget {
  const SelectTaskPage({Key? key}) : super(key: key);

  @override
  _SelectTaskPageState createState() => _SelectTaskPageState();
}

class _SelectTaskPageState extends State<SelectTaskPage> {
  final UserService _userService = UserService();
  int _currentLevel = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLevel();
  }

  Future<void> _loadUserLevel() async {
    try {
      await _userService.syncUser(auth.FirebaseAuth.instance.currentUser);
      if (mounted) {
        setState(() {
          _currentLevel = _userService.user.currentLevel;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentLevel = 1; // Fallback to level 1 on error
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching level: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get the screen size for responsiveness
    final Size screenSize = MediaQuery.of(context).size;

    // Define our purple color palette based on 0xFF636AE8
    final Color primaryPurple = const Color(0xFF636AE8); // Main purple color
    final Color lightPurple = const Color(0xFF8E95F0); // Lighter shade (approximated)
    final Color darkPurple = const Color(0xFF3B46C4); // Darker shade (approximated)
    final Color veryLightPurple = const Color(0xFFD1D5FA); // Very light shade (approximated)

    return Scaffold(
      // Removed the AppBar to eliminate the logo and "Select Task" title
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                veryLightPurple.withOpacity(0.3),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.05, // Responsive padding
              vertical: screenSize.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    bottom: screenSize.height * 0.02,
                    top: screenSize.height * 0.01,
                  ),
                  child: Text(
                    'What would you like to do today?',
                    style: TextStyle(
                      fontSize: screenSize.width > 600 ? 22 : 18,
                      fontWeight: FontWeight.w500,
                      color: darkPurple,
                    ),
                  ),
                ),

                // Daily Word Challenge Card
                _buildTaskCard(
                  context,
                  title: 'Daily Word Challenge',
                  subtitle: 'Your Daily Streak: 0 Days',
                  iconData: Icons.calendar_today,
                  primaryColor: primaryPurple,
                  lightColor: lightPurple,
                  darkColor: darkPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyChallengeScreen(),
                      ),
                    );
                  },
                  screenSize: screenSize,
                ),

                SizedBox(height: screenSize.height * 0.02),

                // Quizzes Card
                _buildTaskCard(
                  context,
                  title: 'Quizzes',
                  subtitle: 'Current Level: $_currentLevel',
                  iconData: Icons.quiz,
                  primaryColor: primaryPurple,
                  lightColor: lightPurple,
                  darkColor: darkPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizPage(),
                      ),
                    );
                  },
                  screenSize: screenSize,
                ),

                const Spacer(),

                // Footer: "Want to learn more? Go to Learning"
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.02,
                    horizontal: screenSize.width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: veryLightPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkPurple.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: darkPurple,
                        size: screenSize.width > 600 ? 26 : 22,
                      ),
                      SizedBox(width: screenSize.width * 0.02),
                      Text(
                        'Want to learn More?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: darkPurple,
                          fontSize: screenSize.width > 600 ? 18 : 14,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LearningPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.03,
                            vertical: screenSize.height * 0.01,
                          ),
                        ),
                        child: Text(
                          'Go to Learning',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData iconData,
        required Color primaryColor,
        required Color lightColor,
        required Color darkColor,
        required VoidCallback onTap,
        required Size screenSize,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightColor, primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Section with Icon
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenSize.width * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            color: Colors.white,
                            size: screenSize.width > 600 ? 28 : 24,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.04),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: screenSize.width > 600 ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: screenSize.height * 0.005),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: screenSize.width > 600 ? 16 : 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Section (Continue button)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.04,
                            vertical: screenSize.height * 0.01,
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: darkColor,
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width > 600 ? 16 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

