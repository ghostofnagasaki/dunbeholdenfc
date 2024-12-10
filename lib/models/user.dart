class AppUser {
  String id; // Change from final String id; to String id;
  final String email;
  final String name;
  final String role; // 'teacher' or 'student'


  AppUser({
    required this.id, // Update constructor to accept id
    required this.email,
    required this.name,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
