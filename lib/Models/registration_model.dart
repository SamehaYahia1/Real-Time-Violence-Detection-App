class RegisterModel {
  final String fullname;
  final String username;
  final String email;
  final String password;
  final String role;

  const RegisterModel({
    required this.fullname,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "username": username,
      "email": email,
      "password": password,
      "role": role
    };
  }
}
