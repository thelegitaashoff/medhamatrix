class SignupRequest {
  final String fullName;
  final String dob;
  final String mobile;
  final String email;
  final String password;
  final String role;

  SignupRequest({
    required this.fullName,
    required this.dob,
    required this.mobile,
    required this.email,
    required this.password,
    this.role = 'student',
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'dob': dob,
      'mobile': mobile,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'SignupRequest{fullName: $fullName, dob: $dob, mobile: $mobile, email: $email, role: $role}';
  }
}
