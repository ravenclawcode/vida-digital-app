class User {
  final String id;
  final String email;
  final String username;
  final String password;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    this.isActive = false,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }
}
