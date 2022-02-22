class UserModel {
  final String name;
  final String email;
  final String uid;
  final DateTime createdAt;

  UserModel({
    required this.name,
    required this.uid,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
