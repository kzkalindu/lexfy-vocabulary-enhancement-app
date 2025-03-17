import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/quiz.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzesByLevel(int level) async {
    final snapshot = await _firestore
        .collection('quizzes')
        .where('level', isEqualTo: level)
        .limit(5)
        .get();
    return snapshot.docs.map((doc) => Quiz.fromJson(doc.data())).toList();
  }
}

