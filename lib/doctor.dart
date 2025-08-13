class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final String? additionalInfo;
  final List<String>? education;
  final List<String>? experience;
  final List<String>? skills;
  final String? roleDescription;
  final List<String>? socialContributions;

  Doctor({
    required this.name, 
    required this.specialty, 
    required this.imageUrl, 
    this.additionalInfo,
    this.education,
    this.experience,
    this.skills,
    this.roleDescription,
    this.socialContributions,
  });
}
