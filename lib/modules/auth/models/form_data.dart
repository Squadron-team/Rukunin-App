class SignInFormData {
  final String email;
  final String password;

  SignInFormData({required this.email, required this.password});
}

class SignUpFormData {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
