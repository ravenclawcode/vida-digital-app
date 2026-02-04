class User {
  final String id;
  final String username;
  final String email;
  final String? gender;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.gender,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id']?.toString() ?? '',
    username: json['username'] ?? 'User',
    email: json['email'] ?? '',
    gender: json['gender'],
    profilePhotoUrl: json['profile_photo_url'] ?? json['profile_photo'],
  );
}
}
