class User {
  final String id;
  final String email;
  final String username;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
