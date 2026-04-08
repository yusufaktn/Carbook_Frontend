/// Register request model
class RegisterRequest {
  final String userName;
  final String userLastName;
  final String email;
  final String password;

  RegisterRequest({
    required this.userName,
    required this.userLastName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userLastName': userLastName,
      'email': email,
      'password': password,
    };
  }
}
