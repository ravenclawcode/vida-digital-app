class User {
  final String id;
  final String username;
  final String email;
  final int roleId;
  final String? gender;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    this.gender,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? 'User',
      email: json['email'] ?? '',
      roleId: json['role_id'] is int
          ? json['role_id']
          : int.tryParse(json['role_id']?.toString() ?? '3') ?? 3,
      gender: json['gender'],
      profilePhotoUrl: json['profile_photo_url'] ?? json['profile_photo'],
    );
  }
}
