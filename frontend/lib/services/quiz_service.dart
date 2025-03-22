// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:frontend/models/quiz.dart';
//
// class QuizService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<Quiz>> getQuizzesByLevel(int level) async {
//     final snapshot = await _firestore
//         .collection('quizzes')
//         .where('level', isEqualTo: level)
//         .limit(5)
//         .get();
//     return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
//   }
// }
//

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:frontend/models/quiz.dart';
//
// class QuizService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<Quiz>> getQuizzesByLevel(int level) async {
//     try {
//       final snapshot = await _firestore
//           .collection('quizzes')
//           .where('level', isEqualTo: level)
//           .limit(5)
//           .get();
//
//       return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
//     } catch (e) {
//       print('Quiz fetch error: $e');
//       return []; // Fallback to empty list if Firestore fails
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/quiz.dart';

class QuizService {
  int _mapUserLevelToQuizLevel(int userLevel) {
    if (userLevel >= 1 && userLevel <= 20) {
      return 1; // Levels 1-20 use quizzes with level 1
    } else if (userLevel >= 21 && userLevel <= 40) {
      return 2; // Levels 21-40 use quizzes with level 2
    } else if (userLevel >= 41 && userLevel <= 60) {
      return 3; // Levels 41-60 use quizzes with level 3
    } else {
      return 1; // Fallback to level 1 for invalid ranges
    }
  }

  Future<List<Map<String, dynamic>>> getQuizzesByLevel(int userLevel, List<String> usedQuizzes) async {
    try {
      int quizLevel = _mapUserLevelToQuizLevel(userLevel);
      print('User Level $userLevel mapped to Quiz Level $quizLevel, excluding used quizzes: $usedQuizzes');

      // Fetch all quizzes for the given level without using whereNotIn
      final snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('level', isEqualTo: quizLevel)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No quizzes found for Quiz Level $quizLevel');
        return [];
      }

      // Filter out used quizzes in Dart
      final availableQuizzes = snapshot.docs
          .where((doc) => !usedQuizzes.contains(doc.id))
          .map((doc) => {
        'id': doc.id,
        'quiz': Quiz.fromJson(doc.data()),
      })
          .toList();

      if (availableQuizzes.isEmpty) {
        print('No new quizzes available after filtering used quizzes');
        return [];
      }

      // Shuffle and take up to 5 quizzes
      availableQuizzes.shuffle();
      return availableQuizzes.take(5).toList();
    } catch (e) {
      print('Error fetching quizzes for User Level $userLevel: $e');
      throw e;
    }
  }
}