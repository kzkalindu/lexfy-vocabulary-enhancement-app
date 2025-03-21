// class Quiz {
//   final String question;
//   final List<String> options;
//   final int answerIndex;
//   final String category;
//   final int level;
//
//   Quiz({
//     required this.question,
//     required this.options,
//     required this.answerIndex,
//     required this.category,
//     required this.level,
//   });
//
//   factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
//     question: json['question'],
//     options: List<String>.from(json['options']),
//     answerIndex: json['answerIndex'],
//     category: json['category'],
//     level: json['level'],
//   );
// }
//

class Quiz {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String category;
  final int level;

  Quiz({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.category,
    required this.level,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    question: json['question'],
    options: List<String>.from(json['options']),
    answerIndex: json['answerIndex'],
    category: json['category'],
    level: json['level'],
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'answerIndex': answerIndex,
    'category': category,
    'level': level,
  };
}