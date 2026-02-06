class PhqCode {
  final String id;
  final String code;

  PhqCode({required this.id, required this.code});

  factory PhqCode.fromJson(Map<String, dynamic> json) {
    return PhqCode(id: json['id'].toString(), code: json['token_code'] ?? '');
  }
}
