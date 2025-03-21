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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/quiz.dart';

class QuizService {
  final String baseUrl = 'http://lexfy-vocabulary-enhancement-app.onrender.com/api';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzesByLevel(int level) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Attempt to fetch from backend
      final token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$baseUrl/quizzes?level=$level'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception('Backend fetch failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Falling back to Firestore for quizzes: $e');
      // Fallback to Firestore
      final snapshot = await _firestore
          .collection('quizzes')
          .where('level', isEqualTo: level)
          .limit(5)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
    }
  }
}