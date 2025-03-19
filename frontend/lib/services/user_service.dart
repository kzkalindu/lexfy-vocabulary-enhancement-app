import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/user.dart' as model; // Alias the custom User class
import '../utils/constants.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  model.User _user = model.User(uid: ''); // Use the aliased User

  model.User get user => _user; // Use the aliased User

  Future<void> syncUser(User? user) async {
    if (user == null) return; // Handle case where user is not authenticated
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      _user = model.User( // Use the aliased User
        uid: user.uid,
        email: user.email,
        currentLevel: 1,
        xpPoints: 0,
        rank: 'Newbie',
        completedLevels: const [1],
       
      );
      await _firestore.collection('users').doc(_user.uid).set(_user.toJson());
    } else {
      _user = model.User.fromJson(userDoc.data()!); // Use the aliased User
    }
  }

  Future<void> updateUserProgress({int? currentLevel, int? xpPoints, List<int>? completedLevels}) async {
    if (_auth.currentUser != null) {
      final updatedUser = model.User( // Use the aliased User
        uid: _user.uid,
        email: _user.email,
        currentLevel: currentLevel ?? _user.currentLevel,
        xpPoints: xpPoints ?? _user.xpPoints,
        rank: calculateRank(xpPoints ?? _user.xpPoints),
        completedLevels: completedLevels ?? _user.completedLevels,
      );
      await _firestore.collection('users').doc(_user.uid).update(updatedUser.toJson());
      _user = updatedUser;
    }
  }

  String calculateRank(int xp) {
    if (xp >= Constants.RANKS_MASTER_XP) return 'Master';
    if (xp >= Constants.RANKS_EXPERT_XP) return 'Expert';
    if (xp >= Constants.RANKS_LEARNER_XP) return 'Learner';
    return 'Newbie';
  }
}

