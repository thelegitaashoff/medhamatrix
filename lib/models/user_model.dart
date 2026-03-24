class UserModel {
  String fullName;
  int age;
  String birthday;
  String school;
  int? schoolId;
  String email;
  String phone;
  
  UserModel({
    required this.fullName,
    required this.age,
    required this.birthday,
    required this.school,
    this.schoolId,
    required this.email,
    required this.phone,
  });
  
  // Get username (which is the full name)
  String get username => fullName;
  
  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'birthday': birthday,
      'school': school,
      'schoolId': schoolId,
      'email': email,
      'phone': phone,
    };
  }
  
  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      age: json['age'] ?? 0,
      birthday: json['birthday'] ?? '',
      school: json['school'] ?? '',
      schoolId: json['schoolId'] as int?,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
  
  // Create a copy with updated values
  UserModel copyWith({
    String? fullName,
    int? age,
    String? birthday,
    String? school,
    int? schoolId,
    String? email,
    String? phone,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      birthday: birthday ?? this.birthday,
      school: school ?? this.school,
      schoolId: schoolId ?? this.schoolId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
