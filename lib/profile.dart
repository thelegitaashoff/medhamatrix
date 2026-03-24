import 'package:flutter/material.dart';
import 'package:medhamatrix/l10n/app_localizations.dart';
import 'package:medhamatrix/medha_ui.dart';
import 'package:medhamatrix/services/api_service.dart';
import 'package:medhamatrix/services/user_service.dart';

class EditableProfilePage extends StatefulWidget {
  final bool startEditing;

  const EditableProfilePage({super.key, this.startEditing = false});

  @override
  State<EditableProfilePage> createState() => _EditableProfilePageState();
}

class _EditableProfilePageState extends State<EditableProfilePage> {
  bool isEditing = false;
  bool _isLoading = false;

  String name = '';
  int age = 0;
  String birthday = '';
  String school = '';
  int? schoolId;
  String email = '';
  String phone = '';
  List<_SchoolOption> _schoolOptions = const [];

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    await UserService.initialize();
    if (UserService.authToken != null && UserService.authToken!.isNotEmpty) {
      try {
        await UserService.fetchUserProfileFromAPI();
      } catch (_) {}
    }
    final user = UserService.currentUser;
    if (user != null) {
      name = user.fullName;
      age = user.age;
      birthday = user.birthday;
      school = user.school;
      schoolId = user.schoolId;
      email = user.email;
      phone = user.phone;
    }
    await _loadSchoolOptions();
    _syncControllers();
    isEditing = widget.startEditing;
    if (mounted) setState(() => _isLoading = false);
  }

  void _syncControllers() {
    nameController.text = name;
    ageController.text = age == 0 ? '' : age.toString();
    birthdayController.text = birthday;
    emailController.text = email;
    phoneController.text = phone;
  }

  Future<void> _loadSchoolOptions() async {
    try {
      final response = await ApiService.getSchoolCollegeNames(UserService.authToken);
      if (!response.success || response.data == null) {
        return;
      }

      final options = _extractSchoolOptions(response.data!);
      if (options.isEmpty) {
        return;
      }

      if (schoolId != null) {
        final current = options.where((option) => option.id == schoolId).firstOrNull;
        if (current != null) {
          school = current.name;
        }
      } else if (school.isNotEmpty) {
        final matched = options.where((option) => option.name == school).firstOrNull;
        if (matched != null) {
          schoolId = matched.id;
          school = matched.name;
        }
      }

      _schoolOptions = options;
    } catch (_) {}
  }

  List<_SchoolOption> _extractSchoolOptions(Map<String, dynamic> payload) {
    final candidates = [
      payload['data'],
      payload['results'],
      payload['items'],
      payload['schools'],
      payload['colleges'],
      payload,
    ];

    for (final candidate in candidates) {
      final options = _parseSchoolList(candidate);
      if (options.isNotEmpty) {
        return options;
      }
    }

    return const [];
  }

  List<_SchoolOption> _parseSchoolList(dynamic source) {
    if (source is List) {
      return source
          .map((item) => _SchoolOption.fromDynamic(item))
          .whereType<_SchoolOption>()
          .toList();
    }

    if (source is Map<String, dynamic>) {
      final nested = [
        source['data'],
        source['results'],
        source['items'],
        source['schools'],
        source['colleges'],
      ];

      for (final candidate in nested) {
        final options = _parseSchoolList(candidate);
        if (options.isNotEmpty) {
          return options;
        }
      }
    }

    return const [];
  }

  Future<void> _saveProfile() async {
    if (schoolId == null || school.isEmpty) {
      _snack('Please select your school', isError: true);
      return;
    }

    if (birthdayController.text.trim().isEmpty) {
      _snack('Please enter date of birth', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await UserService.updateUserProfileToAPI(
        schoolId: schoolId!,
        schoolName: school,
        birthday: birthdayController.text.trim(),
      );
      if (success) {
        setState(() {
          birthday = birthdayController.text.trim();
          isEditing = false;
        });
        _snack('Profile updated successfully');
      } else {
        _snack('Failed to update profile', isError: true);
      }
    } catch (_) {
      _snack('Error updating profile', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? MedhaColors.danger : MedhaColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Profile', subtitle: 'Manage your account'),
      child: MedhaPageView(
        children: [
          MedhaHeroCard(
            leading: CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/avatar.jpg'),
            ),
            title: name.isEmpty ? 'MedhaMatrix User' : name,
            subtitle: email.isEmpty ? 'Update your contact information' : email,
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator(color: MedhaColors.primary)),
                  )
                : Column(
                    children: [
                      _buildField(localizations.name, nameController, false),
                      _buildField(localizations.email, emailController, false, keyboardType: TextInputType.emailAddress),
                      _buildSchoolField(localizations.school),
                      _buildField(localizations.phone, phoneController, false, keyboardType: TextInputType.phone),
                      _buildField(localizations.age, ageController, false, keyboardType: TextInputType.number),
                      _buildField(localizations.birthday, birthdayController, isEditing),
                      if (isEditing)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'You can update your school and date of birth here.',
                              style: TextStyle(
                                fontSize: 13,
                                color: MedhaColors.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (isEditing) ...[
                        MedhaPrimaryButton(label: 'Save Profile', icon: Icons.check_rounded, onPressed: _saveProfile),
                        const SizedBox(height: 12),
                        MedhaOutlineButton(
                          label: 'Cancel',
                          onPressed: () {
                            _syncControllers();
                            setState(() => isEditing = false);
                          },
                        ),
                      ] else
                        SizedBox(
                          width: 220,
                          child: MedhaPrimaryButton(
                            label: localizations.editProfile,
                            icon: Icons.edit_rounded,
                            onPressed: () => setState(() => isEditing = true),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool editable, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: MedhaColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MedhaColors.border),
      ),
      child: editable
          ? TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(labelText: label, border: InputBorder.none),
            )
          : Row(
              children: [
                Text(
                  '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: MedhaColors.text),
                ),
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? '-' : controller.text,
                    style: const TextStyle(fontSize: 15, color: MedhaColors.text),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSchoolField(String label) {
    final hasSelectedSchool =
        schoolId != null && _schoolOptions.any((option) => option.id == schoolId);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: MedhaColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MedhaColors.border),
      ),
      child: isEditing
          ? DropdownButtonFormField<int>(
              value: hasSelectedSchool ? schoolId : null,
              isExpanded: true,
              items: _schoolOptions
                  .map(
                    (option) => DropdownMenuItem<int>(
                      value: option.id,
                      child: Text(
                        option.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                final selected = _schoolOptions.where((option) => option.id == value).firstOrNull;
                if (selected == null) return;
                setState(() {
                  schoolId = selected.id;
                  school = selected.name;
                });
              },
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                hintText: _schoolOptions.isEmpty ? 'Loading schools...' : 'Select school',
              ),
            )
          : Row(
              children: [
                Text(
                  '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: MedhaColors.text),
                ),
                Expanded(
                  child: Text(
                    school.isEmpty ? '-' : school,
                    style: const TextStyle(fontSize: 15, color: MedhaColors.text),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SchoolOption {
  final int id;
  final String name;

  const _SchoolOption({
    required this.id,
    required this.name,
  });

  static _SchoolOption? fromDynamic(dynamic source) {
    if (source is! Map) return null;

    final map = Map<String, dynamic>.from(source as Map);
    final rawId = map['id'] ?? map['pk'] ?? map['value'];
    final id = rawId is int ? rawId : int.tryParse('$rawId');
    final name = (map['name'] ?? map['sclname'] ?? map['title'] ?? map['label'] ?? '').toString().trim();

    if (id == null || name.isEmpty) {
      return null;
    }

    return _SchoolOption(id: id, name: name);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
