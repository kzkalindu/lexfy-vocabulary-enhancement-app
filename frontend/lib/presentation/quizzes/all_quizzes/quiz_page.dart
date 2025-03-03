// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class QuizScreen extends StatelessWidget {
//   const QuizScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Color(0xFF6B68FF), // Purple background color
//         child: Column(
//           children: [
//             // Status bar spacing
//             SizedBox(height: 40),
//
//             // App bar with back button and larger logo
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   // Back button in the left corner
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ),
//                   ),
//
//                   // Larger centered logo
//                   Expanded(
//                     child: Center(
//                       child: Image.asset(
//                         'assets/images/logos/Logo-White.png',
//                         height: 40, // Increased logo size
//                       ),
//                     ),
//                   ),
//
//                   // Empty space to balance the layout
//                   SizedBox(width: 40),
//                 ],
//               ),
//             ),
//
//             // XP and Level indicator in one line below logo
//             Padding(
//               padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // XP points display
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                           size: 20,
//                         ),
//                         SizedBox(width: 6),
//                         Text(
//                           '250 XP',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(width: 20), // Space between XP and Level
//
//                   // Level indicator
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//                     ),
//                     child: Text(
//                       'Level 01',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 10), // Additional spacing
//
//             // Game content - scrollable list of levels with varying X positions
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 itemCount: 32, // 1 active + 1 gray + 30 locked buttons
//                 itemBuilder: (context, index) {
//                   // Calculate a consistent X offset for each button
//                   // Using index ensures the same offset is used each time
//                   final xOffset = index % 2 == 0
//                       ? -30.0 - (index % 5 * 6)
//                       : 30.0 + (index % 5 * 6);
//
//                   if (index == 0) {
//                     // Active level button (red)
//                     return Align(
//                       alignment: Alignment.center + Alignment(xOffset / 100, 0),
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20),
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Text(
//                             '01',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   } else if (index == 1) {
//                     // Gray button (no lock)
//                     return Align(
//                       alignment: Alignment.center + Alignment(xOffset / 100, 0),
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20),
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[700],
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     // Locked level buttons
//                     return Align(
//                       alignment: Alignment.center + Alignment(xOffset / 100, 0),
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20),
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[700],
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.lock,
//                             color: Colors.black54,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

// Model class for user progress
class UserProgress {
  final int id;
  final int userId;
  final int xpPoints;
  final int currentLevel;
  final List<int> completedLevels;

  UserProgress({
    required this.id,
    required this.userId,
    required this.xpPoints,
    required this.currentLevel,
    required this.completedLevels,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      userId: json['userId'],
      xpPoints: json['xpPoints'],
      currentLevel: json['currentLevel'],
      completedLevels: List<int>.from(json['completedLevels']),
    );
  }
}

// Model class for quiz level
class QuizLevel {
  final int id;
  final String title;
  final bool isLocked;
  final bool isActive;

  QuizLevel({
    required this.id,
    required this.title,
    required this.isLocked,
    required this.isActive,
  });

  factory QuizLevel.fromJson(Map<String, dynamic> json) {
    return QuizLevel(
      id: json['id'],
      title: json['title'],
      isLocked: json['isLocked'],
      isActive: json['isActive'],
    );
  }
}

// Service to handle API calls
class ApiService {
  final String baseUrl = 'http://your-backend-url.com/api'; // Replace with your actual API URL

  // Get user progress
  Future<UserProgress> getUserProgress(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/progress'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UserProgress.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user progress');
    }
  }

  // Get quiz levels
  Future<List<QuizLevel>> getQuizLevels(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/levels?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> levelsJson = json.decode(response.body);
      return levelsJson.map((json) => QuizLevel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quiz levels');
    }
  }

  // Start a quiz level
  Future<void> startQuizLevel(int userId, int levelId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/levels/$levelId/start'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start quiz level');
    }
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  UserProgress? _userProgress;
  List<QuizLevel> _quizLevels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming user ID 1 for now - in a real app, you'd get this from authentication
      final userId = 1;

      // Load user progress
      final userProgress = await _apiService.getUserProgress(userId);

      // Load quiz levels
      final quizLevels = await _apiService.getQuizLevels(userId);

      setState(() {
        _userProgress = userProgress;
        _quizLevels = quizLevels;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors - you might want to show a snackbar or dialog
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleLevelTap(QuizLevel level) async {
    if (!level.isLocked) {
      try {
        // Assuming user ID 1 for now
        await _apiService.startQuizLevel(1, level.id);

        // Navigate to the quiz for this level
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('Level ${level.title}')),
              body: Center(child: Text('Quiz for level ${level.title}')),
              // In a real app, you'd navigate to your actual quiz screen
            ),
          ),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start level: $e')),
        );
      }
    } else {
      // Show message that level is locked
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complete previous levels to unlock this one!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF6B68FF), // Purple background color
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
          children: [
            // Status bar spacing
            SizedBox(height: 40),

            // App bar with back button and larger logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Back button in the left corner
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),

                  // Larger centered logo
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/logos/Logo-White.png',
                        height: 60, // Increased logo size
                      ),
                    ),
                  ),

                  // Empty space to balance the layout
                  SizedBox(width: 40),
                ],
              ),
            ),

            // XP and Level indicator in one line below logo
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // XP points display - now showing actual user's XP
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${_userProgress?.xpPoints ?? 0} XP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 20), // Space between XP and Level

                  // Level indicator - now showing actual user's level
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      'Level ${_userProgress?.currentLevel.toString().padLeft(2, '0') ?? '01'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10), // Additional spacing

            // Game content - scrollable list of levels with varying X positions
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 20),
                itemCount: _quizLevels.length,
                itemBuilder: (context, index) {
                  final level = _quizLevels[index];

                  // Calculate a consistent X offset for each button
                  // Using index ensures the same offset is used each time
                  final xOffset = index % 2 == 0
                      ? -30.0 - (index % 5 * 6)
                      : 30.0 + (index % 5 * 6);

                  // Determine button appearance based on level status
                  Color buttonColor;
                  Widget buttonContent;

                  if (level.isActive) {
                    // Active level button (red)
                    buttonColor = Colors.red;
                    buttonContent = Text(
                      level.title.padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (!level.isLocked) {
                    // Unlocked but not active level (gray without lock)
                    buttonColor = Colors.grey[700]!;
                    buttonContent = Text(
                      level.title.padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    // Locked level (gray with lock icon)
                    buttonColor = Colors.grey[700]!;
                    buttonContent = Icon(
                      Icons.lock,
                      color: Colors.black54,
                      size: 24,
                    );
                  }

                  return GestureDetector(
                    onTap: () => _handleLevelTap(level),
                    child: Align(
                      alignment: Alignment.center + Alignment(xOffset / 100, 0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(child: buttonContent),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}