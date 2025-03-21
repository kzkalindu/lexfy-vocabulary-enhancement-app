// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:frontend/models/quiz.dart';
// import 'package:frontend/services/quiz_service.dart';
// import 'package:frontend/services/user_service.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import '../../../utils/constants.dart';
//
// class QuizPage extends StatefulWidget {
//   const QuizPage({Key? key}) : super(key: key);
//
//   @override
//   _QuizPageState createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   final QuizService _quizService = QuizService();
//   final UserService _userService = UserService();
//   final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
//   List<Quiz> _quizzes = [];
//   int _currentQuizIndex = 0;
//   String? _selectedAnswer;
//   bool _isLoading = true;
//   bool _isAnswered = false;
//   int _correctAnswers = 0;
//   int _currentLevel = 1;
//   bool _showWelcome = true;
//   bool _showLevelSelection = false;
//   bool _hasError = false; // Track if there's a backend error
//   String _errorMessage = ''; // Store error message
//   final int _maxLevels = 60;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _syncUser().then((_) {
//       if (mounted && !_hasError) {
//         setState(() {
//           _showWelcome = true;
//         });
//         _loadQuizzes();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadQuizzes() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoading = true;
//       _hasError = false; // Reset error state
//     });
//     try {
//       _quizzes = await _quizService.getQuizzesByLevel(_currentLevel);
//       if (_quizzes.isEmpty) {
//         throw Exception('No quizzes available for Level $_currentLevel');
//       }
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _showWelcome = true;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _errorMessage = 'Failed to load quizzes: $e';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading quizzes: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _syncUser() async {
//     if (!mounted) return;
//     if (_auth.currentUser != null) {
//       try {
//         await _userService.syncUser(_auth.currentUser!);
//         if (!mounted) return;
//         setState(() {
//           _currentLevel = _userService.user.currentLevel;
//         });
//       } catch (e) {
//         if (!mounted) return;
//         setState(() {
//           _hasError = true;
//           _errorMessage = 'Failed to sync user data: $e';
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error syncing user data: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'No user logged in. Please log in to continue.';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No user logged in. Please log in to continue.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _submitAnswer() {
//     if (_selectedAnswer != null && !_isAnswered) {
//       setState(() {
//         _isAnswered = true;
//         if (_selectedAnswer == _quizzes[_currentQuizIndex].options[_quizzes[_currentQuizIndex].answerIndex]) {
//           _correctAnswers++;
//           _updateXP(Constants.XP_CORRECT_ANSWER);
//         } else {
//           _updateXP(Constants.XP_WRONG_ANSWER);
//         }
//       });
//     }
//   }
//
//   void _nextQuestion() {
//     if (_currentQuizIndex < _quizzes.length - 1) {
//       setState(() {
//         _currentQuizIndex++;
//         _selectedAnswer = null;
//         _isAnswered = false;
//       });
//     } else {
//       _checkLevelCompletion();
//     }
//   }
//
//   void _checkLevelCompletion() {
//     if (_correctAnswers >= 4) {
//       _updateXP(Constants.XP_PASS_LEVEL);
//       final newLevel = _currentLevel + 1;
//       _userService.updateUserProgress(
//         currentLevel: newLevel,
//         completedLevels: [..._userService.user.completedLevels, _currentLevel],
//       );
//       if (!mounted) return;
//       setState(() {
//         _currentLevel = newLevel;
//         _currentQuizIndex = 0;
//         _correctAnswers = 0;
//         _isAnswered = false;
//         _selectedAnswer = null;
//         _showWelcome = true;
//       });
//       _loadQuizzes();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Level Completed! Moving to Level $_currentLevel'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _currentQuizIndex = 0;
//         _correctAnswers = 0;
//         _isAnswered = false;
//         _selectedAnswer = null;
//       });
//       _loadQuizzes();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Try again! You need 4/5 correct.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _updateXP(int xp) {
//     if (_auth.currentUser != null) {
//       _userService.updateUserProgress(xpPoints: _userService.user.xpPoints + xp);
//     }
//   }
//
//   void _startQuiz() {
//     setState(() {
//       _showWelcome = false;
//     });
//   }
//
//   void _toggleLevelSelection() {
//     setState(() {
//       _showLevelSelection = !_showLevelSelection;
//     });
//   }
//
//   void _selectLevel(int level) {
//     setState(() {
//       _currentLevel = level;
//       _currentQuizIndex = 0;
//       _correctAnswers = 0;
//       _isAnswered = false;
//       _selectedAnswer = null;
//       _showWelcome = true;
//       _showLevelSelection = false;
//     });
//     _loadQuizzes();
//   }
//
//   bool _isLevelUnlocked(int level) {
//     return level <= _userService.user.currentLevel;
//   }
//
//   Widget _buildLevelSelectionScreen() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Select Level',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: _toggleLevelSelection,
//                 color: Colors.deepPurple,
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: GridView.builder(
//               controller: _scrollController,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1.0,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: _maxLevels,
//               itemBuilder: (context, index) {
//                 final level = index + 1;
//                 final isUnlocked = _isLevelUnlocked(level);
//                 final isCurrentLevel = level == _currentLevel;
//
//                 return GestureDetector(
//                   onTap: isUnlocked ? () => _selectLevel(level) : null,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isCurrentLevel
//                           ? Colors.pink
//                           : (isUnlocked ? Colors.deepPurple : Colors.grey),
//                       boxShadow: [
//                         BoxShadow(
//                           color: (isCurrentLevel ? Colors.pink : Colors.deepPurple).withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: isUnlocked
//                           ? Text(
//                         level.toString().padLeft(2, '0'),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       )
//                           : Icon(
//                         Icons.lock,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.deepPurple,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             'assets/images/logos/Logo-White.png',
//             height: 40,
//           ),
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   'Level ${_currentLevel.toString().padLeft(2, '0')}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   '${_userService.user.xpPoints} XP',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               IconButton(
//                 icon: Icon(Icons.grid_view_rounded, color: Colors.white),
//                 onPressed: _toggleLevelSelection,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorScreen() {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: Center(
//                 child: Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.all(24),
//                   padding: EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 60,
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Error',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         _errorMessage,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: () {
//                           _syncUser().then((_) {
//                             if (!_hasError) {
//                               _loadQuizzes();
//                             }
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.pink,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           elevation: 5,
//                         ),
//                         child: Text(
//                           'Retry',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       );
//     }
//
//     if (_hasError) {
//       return _buildErrorScreen();
//     }
//
//     if (_showLevelSelection) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: _buildLevelSelectionScreen(),
//         ),
//       );
//     }
//
//     if (_showWelcome) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.all(24),
//                     padding: EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Welcome to Level ${_currentLevel.toString().padLeft(2, '0')}!',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           'Complete 4 out of 5 quizzes correctly to advance to the next level!',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         ElevatedButton(
//                           onPressed: _startQuiz,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.pink,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: Text(
//                             'Start Quiz',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     if (_quizzes.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     margin: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'No quizzes available for Level $_currentLevel',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final currentQuiz = _quizzes[_currentQuizIndex];
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Question ${_currentQuizIndex + 1}/5',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.deepPurple.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                             'Level ${_currentLevel.toString().padLeft(2, '0')}',
//                             style: TextStyle(
//                               color: Colors.deepPurple,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           color: Colors.deepPurple.withOpacity(0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: Text(
//                         currentQuiz.question,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ...currentQuiz.options.map<Widget>((option) => Padding(
//                       padding: EdgeInsets.only(bottom: 8),
//                       child: RadioListTile<String>(
//                         title: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: _selectedAnswer == option && _isAnswered
//                                 ? (_selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green.withOpacity(0.1)
//                                 : Colors.red.withOpacity(0.1))
//                                 : Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: _selectedAnswer == option
//                                   ? (_isAnswered
//                                   ? (_selectedAnswer ==
//                                   currentQuiz.options[currentQuiz.answerIndex]
//                                   ? Colors.green
//                                   : Colors.red)
//                                   : Colors.pink)
//                                   : Colors.grey.withOpacity(0.3),
//                               width: 2,
//                             ),
//                           ),
//                           child: Text(
//                             option,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                         value: option,
//                         groupValue: _selectedAnswer,
//                         onChanged: _isAnswered
//                             ? null
//                             : (value) => setState(() => _selectedAnswer = value),
//                         activeColor: Colors.pink,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                     )),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _selectedAnswer == null
//                           ? null
//                           : (_isAnswered ? _nextQuestion : _submitAnswer),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: Text(
//                         _isAnswered ? 'Next' : 'Submit',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (_isAnswered) ...[
//                       SizedBox(height: 20),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: _selectedAnswer ==
//                               currentQuiz.options[currentQuiz.answerIndex]
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: _selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green
//                                 : Colors.red,
//                             width: 2,
//                           ),
//                         ),
//                         child: Text(
//                           _selectedAnswer ==
//                               currentQuiz.options[currentQuiz.answerIndex]
//                               ? 'Correct! Well done!'
//                               : 'Wrong. Correct answer: ${currentQuiz.options[currentQuiz.answerIndex]}',
//                           style: TextStyle(
//                             color: _selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green[800]
//                                 : Colors.red[800],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:frontend/models/quiz.dart';
// import 'package:frontend/services/quiz_service.dart';
// import 'package:frontend/services/user_service.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import '../../../utils/constants.dart';
//
// class QuizPage extends StatefulWidget {
//   const QuizPage({Key? key}) : super(key: key);
//
//   @override
//   _QuizPageState createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   final QuizService _quizService = QuizService();
//   final UserService _userService = UserService();
//   final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
//   List<Quiz> _quizzes = [];
//   int _currentQuizIndex = 0;
//   String? _selectedAnswer;
//   bool _isLoading = true;
//   bool _isAnswered = false;
//   int _correctAnswers = 0;
//   int _currentLevel = 1;
//   bool _showWelcome = true;
//   bool _showLevelSelection = false;
//   bool _hasError = false; // Track if there's a backend error
//   String _errorMessage = ''; // Store error message
//   final int _maxLevels = 60;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _syncUser().then((_) {
//       if (mounted && !_hasError) {
//         setState(() {
//           _showWelcome = true;
//         });
//         _loadQuizzes();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadQuizzes() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoading = true;
//       _hasError = false; // Reset error state
//     });
//     try {
//       _quizzes = await _quizService.getQuizzesByLevel(_currentLevel);
//       if (_quizzes.isEmpty) {
//         throw Exception('No quizzes available for Level $_currentLevel');
//       }
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _showWelcome = true;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _errorMessage = 'Failed to load quizzes: $e';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading quizzes: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _syncUser() async {
//     if (!mounted) return;
//     if (_auth.currentUser != null) {
//       try {
//         await _userService.syncUser(_auth.currentUser!);
//         if (!mounted) return;
//         setState(() {
//           _currentLevel = _userService.user!.currentLevel;
//         });
//       } catch (e) {
//         if (!mounted) return;
//         setState(() {
//           _hasError = true;
//           _errorMessage = 'Failed to sync user data: $e';
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error syncing user data: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _hasError = true;
//         _errorMessage = 'No user logged in. Please log in to continue.';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No user logged in. Please log in to continue.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _submitAnswer() {
//     if (_selectedAnswer != null && !_isAnswered) {
//       setState(() {
//         _isAnswered = true;
//         if (_selectedAnswer == _quizzes[_currentQuizIndex].options[_quizzes[_currentQuizIndex].answerIndex]) {
//           _correctAnswers++;
//           _updateXP(Constants.XP_CORRECT_ANSWER);
//         } else {
//           _updateXP(Constants.XP_WRONG_ANSWER);
//         }
//       });
//     }
//   }
//
//   void _nextQuestion() {
//     if (_currentQuizIndex < _quizzes.length - 1) {
//       setState(() {
//         _currentQuizIndex++;
//         _selectedAnswer = null;
//         _isAnswered = false;
//       });
//     } else {
//       _checkLevelCompletion();
//     }
//   }
//
//   void _checkLevelCompletion() {
//     if (_correctAnswers >= 4) {
//       _updateXP(Constants.XP_PASS_LEVEL);
//       final newLevel = _currentLevel + 1;
//       _userService.updateUserProgress(
//         currentLevel: newLevel,
//         completedLevels: [...?_userService.user?.completedLevels, _currentLevel],
//       );
//       if (!mounted) return;
//       setState(() {
//         _currentLevel = newLevel;
//         _currentQuizIndex = 0;
//         _correctAnswers = 0;
//         _isAnswered = false;
//         _selectedAnswer = null;
//         _showWelcome = true;
//       });
//       _loadQuizzes();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Level Completed! Moving to Level $_currentLevel'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _currentQuizIndex = 0;
//         _correctAnswers = 0;
//         _isAnswered = false;
//         _selectedAnswer = null;
//       });
//       _loadQuizzes();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Try again! You need 4/5 correct.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _updateXP(int xp) {
//     if (_auth.currentUser != null) {
//       _userService.updateUserProgress(xpPoints: _userService.user!.xpPoints + xp);
//     }
//   }
//
//   void _startQuiz() {
//     setState(() {
//       _showWelcome = false;
//     });
//   }
//
//   void _toggleLevelSelection() {
//     setState(() {
//       _showLevelSelection = !_showLevelSelection;
//     });
//   }
//
//   void _selectLevel(int level) {
//     setState(() {
//       _currentLevel = level;
//       _currentQuizIndex = 0;
//       _correctAnswers = 0;
//       _isAnswered = false;
//       _selectedAnswer = null;
//       _showWelcome = true;
//       _showLevelSelection = false;
//     });
//     _loadQuizzes();
//   }
//
//   bool _isLevelUnlocked(int level) {
//     return level <= _userService.user!.currentLevel;
//   }
//
//   Widget _buildLevelSelectionScreen() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Select Level',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: _toggleLevelSelection,
//                 color: Colors.deepPurple,
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: GridView.builder(
//               controller: _scrollController,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 childAspectRatio: 1.0,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: _maxLevels,
//               itemBuilder: (context, index) {
//                 final level = index + 1;
//                 final isUnlocked = _isLevelUnlocked(level);
//                 final isCurrentLevel = level == _currentLevel;
//
//                 return GestureDetector(
//                   onTap: isUnlocked ? () => _selectLevel(level) : null,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isCurrentLevel
//                           ? Colors.pink
//                           : (isUnlocked ? Colors.deepPurple : Colors.grey),
//                       boxShadow: [
//                         BoxShadow(
//                           color: (isCurrentLevel ? Colors.pink : Colors.deepPurple).withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: isUnlocked
//                           ? Text(
//                         level.toString().padLeft(2, '0'),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       )
//                           : Icon(
//                         Icons.lock,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.deepPurple,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             'assets/images/logos/Logo-White.png',
//             height: 40,
//           ),
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   'Level ${_currentLevel.toString().padLeft(2, '0')}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Text(
//                   '${_userService.user?.xpPoints} XP',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               IconButton(
//                 icon: Icon(Icons.grid_view_rounded, color: Colors.white),
//                 onPressed: _toggleLevelSelection,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorScreen() {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: Center(
//                 child: Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.all(24),
//                   padding: EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 60,
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Error',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         _errorMessage,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: _selectedAnswer == null
//                             ? null
//                             : (_isAnswered ? _nextQuestion : _submitAnswer),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.pink,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           elevation: 5, // Removed 'melting'
//                         ),
//                         child: Text(
//                           _isAnswered ? 'Next' : 'Submit',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       );
//     }
//
//     if (_hasError) {
//       return _buildErrorScreen();
//     }
//
//     if (_showLevelSelection) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: _buildLevelSelectionScreen(),
//         ),
//       );
//     }
//
//     if (_showWelcome) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.all(24),
//                     padding: EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Welcome to Level ${_currentLevel.toString().padLeft(2, '0')}!',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           'Complete 4 out of 5 quizzes correctly to advance to the next level!',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         ElevatedButton(
//                           onPressed: _startQuiz,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.pink,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: Text(
//                             'Start Quiz',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     if (_quizzes.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.deepPurple,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     margin: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'No quizzes available for Level $_currentLevel',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final currentQuiz = _quizzes[_currentQuizIndex];
//     return Scaffold(
//       backgroundColor: Colors.deepPurple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Question ${_currentQuizIndex + 1}/5',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.deepPurple.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                             'Level ${_currentLevel.toString().padLeft(2, '0')}',
//                             style: TextStyle(
//                               color: Colors.deepPurple,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           color: Colors.deepPurple.withOpacity(0.2),
//                           width: 1,
//                         ),
//                       ),
//                       child: Text(
//                         currentQuiz.question,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ...currentQuiz.options.map<Widget>((option) => Padding(
//                       padding: EdgeInsets.only(bottom: 8),
//                       child: RadioListTile<String>(
//                         title: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: _selectedAnswer == option && _isAnswered
//                                 ? (_selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green.withOpacity(0.1)
//                                 : Colors.red.withOpacity(0.1))
//                                 : Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: _selectedAnswer == option
//                                   ? (_isAnswered
//                                   ? (_selectedAnswer ==
//                                   currentQuiz.options[currentQuiz.answerIndex]
//                                   ? Colors.green
//                                   : Colors.red)
//                                   : Colors.pink)
//                                   : Colors.grey.withOpacity(0.3),
//                               width: 2,
//                             ),
//                           ),
//                           child: Text(
//                             option,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                         value: option,
//                         groupValue: _selectedAnswer,
//                         onChanged: _isAnswered
//                             ? null
//                             : (value) => setState(() => _selectedAnswer = value),
//                         activeColor: Colors.pink,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                     )),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _selectedAnswer == null
//                           ? null
//                           : (_isAnswered ? _nextQuestion : _submitAnswer),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: Text(
//                         _isAnswered ? 'Next' : 'Submit',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (_isAnswered) ...[
//                       SizedBox(height: 20),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: _selectedAnswer ==
//                               currentQuiz.options[currentQuiz.answerIndex]
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: _selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green
//                                 : Colors.red,
//                             width: 2,
//                           ),
//                         ),
//                         child: Text(
//                           _selectedAnswer ==
//                               currentQuiz.options[currentQuiz.answerIndex]
//                               ? 'Correct! Well done!'
//                               : 'Wrong. Correct answer: ${currentQuiz.options[currentQuiz.answerIndex]}',
//                           style: TextStyle(
//                             color: _selectedAnswer ==
//                                 currentQuiz.options[currentQuiz.answerIndex]
//                                 ? Colors.green[800]
//                                 : Colors.red[800],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/services/quiz_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../../utils/constants.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizService = QuizService();
  final UserService _userService = UserService();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  List<Quiz> _quizzes = [];
  int _currentQuizIndex = 0;
  String? _selectedAnswer;
  bool _isLoading = true;
  bool _isAnswered = false;
  int _correctAnswers = 0;
  int _currentLevel = 1;
  bool _showWelcome = true;
  bool _showLevelSelection = false;
  bool _hasError = false;
  String _errorMessage = '';
  final int _maxLevels = 60;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _syncUser().then((_) {
      if (mounted && !_hasError) {
        setState(() {
          _showWelcome = true;
        });
        _loadQuizzes();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadQuizzes() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      _quizzes = await _quizService.getQuizzesByLevel(_currentLevel);
      if (_quizzes.isEmpty) {
        throw Exception('No quizzes available for Level $_currentLevel');
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _showWelcome = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load quizzes: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading quizzes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _syncUser() async {
    if (!mounted) return;
    if (_auth.currentUser != null) {
      try {
        await _userService.syncUser(_auth.currentUser!);
        if (!mounted) return;
        setState(() {
          _currentLevel = _userService.user.currentLevel;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to sync user data: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error syncing user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'No user logged in. Please log in to continue.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user logged in. Please log in to continue.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitAnswer() {
    if (_selectedAnswer != null && !_isAnswered) {
      setState(() {
        _isAnswered = true;
        if (_selectedAnswer == _quizzes[_currentQuizIndex].options[_quizzes[_currentQuizIndex].answerIndex]) {
          _correctAnswers++;
          _updateXP(Constants.XP_CORRECT_ANSWER);
        } else {
          _updateXP(Constants.XP_WRONG_ANSWER);
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuizIndex < _quizzes.length - 1) {
      setState(() {
        _currentQuizIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _checkLevelCompletion();
    }
  }

  void _checkLevelCompletion() {
    if (_correctAnswers >= 4) {
      _updateXP(Constants.XP_PASS_LEVEL);
      final newLevel = _currentLevel + 1;
      _userService.updateUserProgress(
        currentLevel: newLevel,
        completedLevels: [..._userService.user.completedLevels, _currentLevel],
      );
      if (!mounted) return;
      setState(() {
        _currentLevel = newLevel;
        _currentQuizIndex = 0;
        _correctAnswers = 0;
        _isAnswered = false;
        _selectedAnswer = null;
        _showWelcome = true;
      });
      _loadQuizzes();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Level Completed! Moving to Level $_currentLevel'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;
      setState(() {
        _currentQuizIndex = 0;
        _correctAnswers = 0;
        _isAnswered = false;
        _selectedAnswer = null;
      });
      _loadQuizzes();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Try again! You need 4/5 correct.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateXP(int xp) {
    if (_auth.currentUser != null) {
      _userService.updateUserProgress(xpPoints: _userService.user.xpPoints + xp);
    }
  }

  void _startQuiz() {
    setState(() {
      _showWelcome = false;
    });
  }

  void _toggleLevelSelection() {
    setState(() {
      _showLevelSelection = !_showLevelSelection;
    });
  }

  void _selectLevel(int level) {
    setState(() {
      _currentLevel = level;
      _currentQuizIndex = 0;
      _correctAnswers = 0;
      _isAnswered = false;
      _selectedAnswer = null;
      _showWelcome = true;
      _showLevelSelection = false;
    });
    _loadQuizzes();
  }

  bool _isLevelUnlocked(int level) {
    return level <= _userService.user.currentLevel;
  }

  Widget _buildLevelSelectionScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Level',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: _toggleLevelSelection,
                color: Colors.deepPurple,
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _maxLevels,
              itemBuilder: (context, index) {
                final level = index + 1;
                final isUnlocked = _isLevelUnlocked(level);
                final isCurrentLevel = level == _currentLevel;

                return GestureDetector(
                  onTap: isUnlocked ? () => _selectLevel(level) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentLevel
                          ? Colors.pink
                          : (isUnlocked ? Colors.deepPurple : Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: (isCurrentLevel ? Colors.pink : Colors.deepPurple).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isUnlocked
                          ? Text(
                        level.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                          : Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logos/Logo-White.png',
            height: 40,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Level ${_currentLevel.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_userService.user.xpPoints} XP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.grid_view_rounded, color: Colors.white),
                onPressed: _toggleLevelSelection,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          _syncUser().then((_) {
                            if (!_hasError) {
                              _loadQuizzes();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_hasError) {
      return _buildErrorScreen();
    }

    if (_showLevelSelection) {
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: _buildLevelSelectionScreen(),
        ),
      );
    }

    if (_showWelcome) {
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(24),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to Level ${_currentLevel.toString().padLeft(2, '0')}!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Complete 4 out of 5 quizzes correctly to advance to the next level!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _startQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Start Quiz',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_quizzes.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'No quizzes available for Level $_currentLevel',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuiz = _quizzes[_currentQuizIndex];
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView( // Added to prevent overflow
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Minimize column size
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuizIndex + 1}/5',
                            style: TextStyle(
                              fontSize: 16, // Reduced slightly for responsiveness
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Level ${_currentLevel.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Reduced slightly
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // Reduced spacing
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.15, // Responsive height
                        ),
                        padding: EdgeInsets.all(12), // Reduced padding
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.deepPurple.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView( // Scrollable question text
                          child: Text(
                            currentQuiz.question,
                            style: TextStyle(
                              fontSize: 16, // Reduced for responsiveness
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Reduced spacing
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4, // Responsive options height
                        child: ListView(
                          children: currentQuiz.options.map<Widget>((option) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4), // Reduced padding
                            child: RadioListTile<String>(
                              title: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12), // Reduced padding
                                decoration: BoxDecoration(
                                  color: _selectedAnswer == option && _isAnswered
                                      ? (_selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1))
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedAnswer == option
                                        ? (_isAnswered
                                        ? (_selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                        ? Colors.green
                                        : Colors.red)
                                        : Colors.pink)
                                        : Colors.grey.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14, // Reduced for responsiveness
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Handle long text
                                  maxLines: 2, // Limit lines
                                ),
                              ),
                              value: option,
                              groupValue: _selectedAnswer,
                              onChanged: _isAnswered
                                  ? null
                                  : (value) => setState(() => _selectedAnswer = value),
                              activeColor: Colors.pink,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )).toList(),
                        ),
                      ),
                      SizedBox(height: 16), // Reduced spacing
                      ElevatedButton(
                        onPressed: _selectedAnswer == null
                            ? null
                            : (_isAnswered ? _nextQuestion : _submitAnswer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Reduced padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          _isAnswered ? 'Next' : 'Submit',
                          style: TextStyle(
                            fontSize: 16, // Reduced slightly
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isAnswered) ...[
                        SizedBox(height: 16), // Reduced spacing
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10), // Reduced padding
                          decoration: BoxDecoration(
                            color: _selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                  ? Colors.green
                                  : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            _selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                ? 'Correct! Well done!'
                                : 'Wrong. Correct answer: ${currentQuiz.options[currentQuiz.answerIndex]}',
                            style: TextStyle(
                              color: _selectedAnswer == currentQuiz.options[currentQuiz.answerIndex]
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Reduced for responsiveness
                            ),
                            overflow: TextOverflow.ellipsis, // Handle long text
                            maxLines: 2, // Limit lines
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}