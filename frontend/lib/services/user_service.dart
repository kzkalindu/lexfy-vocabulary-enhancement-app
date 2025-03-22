// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:frontend/models/user.dart' as model; // Alias the custom User class
// import '../utils/constants.dart';
//
// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   model.User _user = model.User(uid: ''); // Use the aliased User
//
//   model.User get user => _user; // Use the aliased User
//
//   Future<void> syncUser(User? user) async {
//     if (user == null) return; // Handle case where user is not authenticated
//     final userDoc = await _firestore.collection('users').doc(user.uid).get();
//     if (!userDoc.exists) {
//       _user = model.User( // Use the aliased User
//         uid: user.uid,
//         email: user.email,
//         currentLevel: 1,
//         xpPoints: 0,
//         rank: 'Newbie',
//         completedLevels: const [1],
//       );
//       await _firestore.collection('users').doc(_user.uid).set(_user.toJson());
//     } else {
//       _user = model.User.fromJson(userDoc.data()!); // Use the aliased User
//     }
//   }
//
//   Future<void> updateUserProgress({int? currentLevel, int? xpPoints, List<int>? completedLevels}) async {
//     if (_auth.currentUser != null) {
//       final updatedUser = model.User( // Use the aliased User
//         uid: _user.uid,
//         email: _user.email,
//         currentLevel: currentLevel ?? _user.currentLevel,
//         xpPoints: xpPoints ?? _user.xpPoints,
//         rank: calculateRank(xpPoints ?? _user.xpPoints),
//         completedLevels: completedLevels ?? _user.completedLevels,
//       );
//       await _firestore.collection('users').doc(_user.uid).update(updatedUser.toJson());
//       _user = updatedUser;
//     }
//   }
//
//   String calculateRank(int xp) {
//     if (xp >= Constants.RANKS_MASTER_XP) return 'Master';
//     if (xp >= Constants.RANKS_EXPERT_XP) return 'Expert';
//     if (xp >= Constants.RANKS_LEARNER_XP) return 'Learner';
//     return 'Newbie';
//   }
// }
//

// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:frontend/models/user.dart' as model;
// import 'package:http/http.dart' as http;
//
// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   model.User? _user;
//
//   model.User? get user => _user;
//
//   Future<void> syncUser(User? user) async {
//     if (user == null) throw Exception('User not authenticated');
//
//     try {
//       // Try syncing with backend (new behavior)
//       final token = await user.getIdToken();
//       final response = await http.post(
//         Uri.parse('http://lexfy-vocabulary-enhancement-app.onrender.com/api/users/progress'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({}),
//       );
//
//       print('Response Status: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _user = model.User.fromJson(jsonDecode(response.body));
//         return;
//       } else {
//         throw Exception('Backend sync failed: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('Falling back to Firestore: $e');
//       // Fallback to original Firestore behavior
//       final doc = await _firestore.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         _user = model.User.fromJson(doc.data()!);
//       } else {
//         _user = model.User(uid: user.uid, email: user.email);
//         await _firestore.collection('users').doc(user.uid).set(_user!.toJson());
//       }
//     }
//   }
//
//   Future<void> updateUserProgress({int? currentLevel, int? xpPoints, List<int>? completedLevels}) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null || _user == null) throw Exception('User not authenticated');
//
//     _user = model.User(
//       uid: _user!.uid,
//       email: _user!.email,
//       currentLevel: currentLevel ?? _user!.currentLevel,
//       xpPoints: xpPoints ?? _user!.xpPoints,
//       completedLevels: completedLevels ?? _user!.completedLevels,
//       rank: _calculateRank(xpPoints ?? _user!.xpPoints),
//     );
//
//     await _firestore.collection('users').doc(user.uid).set(_user!.toJson());
//   }
//
//   String _calculateRank(int xp) {
//     if (xp >= 3000) return 'Master';
//     if (xp >= 1500) return 'Expert';
//     if (xp >= 500) return 'Learner';
//     return 'Newbie';
//   }
// }

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:frontend/models/user.dart' as model;
//
// class UserService {
//   final String baseUrl = 'http://lexfy-vocabulary-enhancement-app.onrender.com/api';
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late model.User _user;
//
//   model.User get user => _user;
//
//   Future<void> syncUser(User? user) async {
//     if (user == null) throw Exception('User not authenticated');
//
//     try {
//       // Attempt to sync with backend
//       final token = await user.getIdToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/users/progress'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({}),
//       );
//
//       print('SyncUser - Backend Response Status: ${response.statusCode}');
//       print('SyncUser - Backend Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _user = model.User.fromJson(jsonDecode(response.body));
//         print('SyncUser - Backend sync successful: ${_user.toJson()}');
//         // Sync to Firestore as well to ensure consistency
//         await _firestore.collection('users').doc(user.uid).set(_user.toJson());
//         return;
//       } else {
//         throw Exception('Backend sync failed: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('SyncUser - Falling back to Firestore: $e');
//       // Fallback to Firestore
//       final doc = await _firestore.collection('users').doc(user.uid).get();
//       if (doc.exists) {
//         _user = model.User.fromJson(doc.data()!);
//         print('SyncUser - Loaded from Firestore: ${_user.toJson()}');
//       } else {
//         _user = model.User(uid: user.uid, email: user.email);
//         await _firestore.collection('users').doc(user.uid).set(_user.toJson());
//         print('SyncUser - Created new user in Firestore: ${_user.toJson()}');
//       }
//     }
//   }
//
//   Future<void> updateUserProgress({int? currentLevel, int? xpPoints, List<int>? completedLevels}) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('User not authenticated');
//
//     try {
//       // Update local user object
//       _user = model.User(
//         uid: _user.uid,
//         email: _user.email,
//         currentLevel: currentLevel ?? _user.currentLevel,
//         xpPoints: xpPoints ?? _user.xpPoints,
//         completedLevels: completedLevels ?? _user.completedLevels,
//         rank: _calculateRank(xpPoints ?? _user.xpPoints),
//       );
//       print('UpdateUserProgress - Local update: ${_user.toJson()}');
//
//       // Attempt backend update
//       final token = await user.getIdToken();
//       final response = await http.post(
//         Uri.parse('$baseUrl/users/progress'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'currentLevel': _user.currentLevel,
//           'xpPoints': _user.xpPoints,
//           'completedLevels': _user.completedLevels,
//         }),
//       );
//
//       print('UpdateUserProgress - Backend Response Status: ${response.statusCode}');
//       print('UpdateUserProgress - Backend Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('UpdateUserProgress - Backend update successful');
//       } else {
//         throw Exception('Backend update failed: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('UpdateUserProgress - Falling back to Firestore: $e');
//     }
//
//     // Always update Firestore, even if backend succeeds, to ensure local persistence
//     try {
//       await _firestore.collection('users').doc(user.uid).set(_user.toJson());
//       print('UpdateUserProgress - Firestore update successful: ${_user.toJson()}');
//     } catch (firestoreError) {
//       print('UpdateUserProgress - Firestore update failed: $firestoreError');
//       throw firestoreError; // Re-throw to handle in UI if needed
//     }
//   }
//
//   String _calculateRank(int xp) {
//     if (xp >= 3000) return 'Master';
//     if (xp >= 1500) return 'Expert';
//     if (xp >= 500) return 'Learner';
//     return 'Newbie';
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user.dart' as model;

class UserService {
  final String baseUrl = 'http://lexfy-vocabulary-enhancement-app.onrender.com/api';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late model.User _user;

  model.User get user => _user;

  Future<void> syncUser(User? user) async {
    if (user == null) {
      print('SyncUser - No user authenticated');
      throw Exception('User not authenticated');
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _user = model.User.fromJson(doc.data()!);
        print('SyncUser - Loaded from Firestore: ${_user.toJson()}');
      } else {
        _user = model.User(uid: user.uid, email: user.email);
        await _firestore.collection('users').doc(user.uid).set(_user.toJson());
        print('SyncUser - Created new user in Firestore: ${_user.toJson()}');
      }
    } catch (e) {
      print('SyncUser - Firestore sync failed: $e');
      throw e;
    }
  }

  Future<void> updateUserProgress({
    int? currentLevel,
    int? xpPoints,
    List<int>? completedLevels,
    int? streak,
    DateTime? lastStreakDate,
    List<String>? usedQuizzes, // New parameter
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('UpdateUserProgress - No user authenticated');
      throw Exception('User not authenticated');
    }

    try {
      // Update local user object
      _user = model.User(
        uid: _user.uid,
        email: _user.email,
        currentLevel: currentLevel ?? _user.currentLevel,
        xpPoints: xpPoints ?? _user.xpPoints,
        completedLevels: completedLevels ?? _user.completedLevels,
        rank: _calculateRank(xpPoints ?? _user.xpPoints),
        streak: streak ?? _user.streak,
        lastStreakDate: lastStreakDate ?? _user.lastStreakDate,
        usedQuizzes: usedQuizzes ?? _user.usedQuizzes,
      );
      print('UpdateUserProgress - Local update: ${_user.toJson()}');

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).set(_user.toJson());
      print('UpdateUserProgress - Firestore update successful: ${_user.toJson()}');

      // Optional: Backend sync
      try {
        final token = await user.getIdToken();
        final response = await http.post(
          Uri.parse('$baseUrl/users/progress'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(_user.toJson()),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('UpdateUserProgress - Backend update successful');
        } else {
          print('UpdateUserProgress - Backend failed: ${response.statusCode}');
        }
      } catch (backendError) {
        print('UpdateUserProgress - Backend sync skipped: $backendError');
      }
    } catch (e) {
      print('UpdateUserProgress - Firestore update failed: $e');
      throw e;
    }
  }

  String _calculateRank(int xp) {
    if (xp >= 3000) return 'Master';
    if (xp >= 1500) return 'Expert';
    if (xp >= 500) return 'Learner';
    return 'Newbie';
  }
}