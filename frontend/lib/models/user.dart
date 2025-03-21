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

class User {
  final String uid;
  final String? email;
  int currentLevel;
  int xpPoints;
  String rank;
  List<int> completedLevels;

  User({
    required this.uid,
    this.email,
    this.currentLevel = 1,
    this.xpPoints = 0,
    this.rank = 'Newbie',
    this.completedLevels = const [1],
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'currentLevel': currentLevel,
    'xpPoints': xpPoints,
    'rank': rank,
    'completedLevels': completedLevels,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'],
    email: json['email'],
    currentLevel: json['currentLevel'],
    xpPoints: json['xpPoints'],
    rank: json['rank'],
    completedLevels: List<int>.from(json['completedLevels']),
  );
}