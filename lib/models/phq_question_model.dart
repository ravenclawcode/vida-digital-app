class PhqQuestion {
  final int id;
  final String questionText;
  final List<PhqOption> options;

  PhqQuestion({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory PhqQuestion.fromJson(Map<String, dynamic> json) {
    return PhqQuestion(
      id: json['id'],
      questionText: json['question_text'],
      options: (json['options'] as List)
          .map((item) => PhqOption.fromJson(item))
          .toList(),
    );
  }
}

class PhqOption {
  final int score;
  final String text;

  PhqOption({required this.score, required this.text});

  factory PhqOption.fromJson(Map<String, dynamic> json) {
    return PhqOption(score: json['score'], text: json['text']);
  }
}
