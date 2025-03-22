// class User {
//   final String uid;
//   final String? email;
//   int currentLevel;
//   int xpPoints;
//   String rank;
//   List<int> completedLevels;
//
//   User({
//     required this.uid,
//     this.email,
//     this.currentLevel = 1,
//     this.xpPoints = 0,
//     this.rank = 'Newbie',
//     this.completedLevels = const [1],
//   });
//
//   Map<String, dynamic> toJson() => {
//     'uid': uid,
//     'email': email,
//     'currentLevel': currentLevel,
//     'xpPoints': xpPoints,
//     'rank': rank,
//     'completedLevels': completedLevels,
//   };
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     uid: json['uid'],
//     email: json['email'],
//     currentLevel: json['currentLevel'],
//     xpPoints: json['xpPoints'],
//     rank: json['rank'],
//     completedLevels: List<int>.from(json['completedLevels']),
//   );
// }
//

// class User {
//   final String uid;
//   final String? email;
//   int currentLevel;
//   int xpPoints;
//   String rank;
//   List<int> completedLevels;
//
//   User({
//     required this.uid,
//     this.email,
//     this.currentLevel = 1,
//     this.xpPoints = 0,
//     this.rank = 'Newbie',
//     this.completedLevels = const [1],
//   });
//
//   Map<String, dynamic> toJson() => {
//     'uid': uid,
//     'email': email,
//     'currentLevel': currentLevel,
//     'xpPoints': xpPoints,
//     'rank': rank,
//     'completedLevels': completedLevels,
//   };
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     uid: json['uid'],
//     email: json['email'],
//     currentLevel: json['currentLevel'],
//     xpPoints: json['xpPoints'],
//     rank: json['rank'],
//     completedLevels: List<int>.from(json['completedLevels']),
//   );
// }

class User {
  final String uid;
  final String? email;
  int currentLevel;
  int xpPoints;
  String rank;
  List<int> completedLevels;
  int streak;
  DateTime? lastStreakDate;
  List<String> usedQuizzes; // New field to track used quiz IDs

  User({
    required this.uid,
    this.email,
    this.currentLevel = 1,
    this.xpPoints = 0,
    this.rank = 'Newbie',
    this.completedLevels = const [1],
    this.streak = 0,
    this.lastStreakDate,
    this.usedQuizzes = const [],
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'currentLevel': currentLevel,
    'xpPoints': xpPoints,
    'rank': rank,
    'completedLevels': completedLevels,
    'streak': streak,
    'lastStreakDate': lastStreakDate?.toIso8601String(),
    'usedQuizzes': usedQuizzes,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'],
    email: json['email'],
    currentLevel: json['currentLevel'] ?? 1,
    xpPoints: json['xpPoints'] ?? 0,
    rank: json['rank'] ?? 'Newbie',
    completedLevels: json['completedLevels'] != null
        ? List<int>.from(json['completedLevels'])
        : [1],
    streak: json['streak'] ?? 0,
    lastStreakDate: json['lastStreakDate'] != null
        ? DateTime.parse(json['lastStreakDate'])
        : null,
    usedQuizzes: json['usedQuizzes'] != null
        ? List<String>.from(json['usedQuizzes'])
        : [],
  );
}