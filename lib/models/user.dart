// models/user.dart

class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? accessToken; // Nullable to handle cases where it might not be present

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.accessToken, // Nullable field
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['UserId'] ?? '', // Provide default empty string if null
      username: json['userName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      accessToken: json['accessToken'] as String?, // Handle nullable
    );
  }
}
