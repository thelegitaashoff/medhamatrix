import 'package:flutter/material.dart';
import 'package:medhamatrix/l10n/app_localizations.dart';
import 'dashboard.dart';
import 'settings.dart';
import 'services/user_service.dart';

class EditableProfilePage extends StatefulWidget {
  final bool startEditing;

  EditableProfilePage({this.startEditing = false});

  @override
  State<EditableProfilePage> createState() => _EditableProfilePageState();
}

class _EditableProfilePageState extends State<EditableProfilePage> {
  bool isEditing = false;
  bool _isLoading = false;

  // Profile data - will be loaded from UserService
  String name = '';
  int age = 0;
  String birthday = '';
  String school = '';
  String email = '';
  String phone = '';

  // Controllers for editing
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final birthdayController = TextEditingController();
  final schoolController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    if (widget.startEditing) {
      _startEditing();
    }
  }
  
  // Load profile data from UserService
  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    
    print('Loading profile data...');
    
    // Initialize UserService first
    await UserService.initialize();
    
    // Check if we have an auth token
    final token = UserService.authToken;
    print('Auth token available: ${token != null ? 'Yes' : 'No'}');
    
    if (token != null && token.isNotEmpty) {
      try {
        // Try to fetch fresh data from API first
        print('Attempting to fetch profile from API...');
        final success = await UserService.fetchUserProfileFromAPI();
        print('API fetch result: $success');
        
        if (!success) {
          print('API fetch failed, showing message to user');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load latest profile data from server. Showing cached data.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        print('Failed to fetch from API: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('No auth token available, using cached data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No authentication token found. Please login again.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    
    // Load current user data (from cache or API)
    final user = UserService.currentUser;
    print('Current user data: ${user?.toJson()}');
    
    if (user != null) {
      setState(() {
        name = user.fullName;
        age = user.age;
        birthday = user.birthday;
        school = user.school;
        email = user.email;
        phone = user.phone;
        _isLoading = false;
      });
      print('Profile data loaded: $name, $email');
    } else {
      print('No user data available');
      setState(() {
        // Set default values if no user data
        name = 'User';
        age = 0;
        birthday = '';
        school = '';
        email = '';
        phone = '';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    birthdayController.dispose();
    schoolController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
      nameController.text = name;
      ageController.text = age.toString();
      birthdayController.text = birthday;
      schoolController.text = school;
      emailController.text = email;
      phoneController.text = phone;
    });
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Update via API first
      final success = await UserService.updateUserProfileToAPI(
        fullName: nameController.text.trim(),
        age: int.tryParse(ageController.text),
        birthday: birthdayController.text.trim(),
        school: schoolController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (success) {
        // Update local state
        setState(() {
          name = nameController.text;
          age = int.tryParse(ageController.text) ?? age;
          birthday = birthdayController.text;
          school = schoolController.text;
          email = emailController.text;
          phone = phoneController.text;
          isEditing = false;
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                SizedBox(height: 24),
                _ProfileFieldBox(
                  label: localizations.name,
                  value: name,
                  isEditing: isEditing,
                  controller: nameController,
                ),
                // Username field showing the full name (read-only)
                _ProfileFieldBox(
                  label: "Username",
                  value: name, // Username automatically updates with name
                  isEditing: false, // Always read-only
                  controller: TextEditingController(text: name), // Controller with current name
                  isReadOnly: true,
                ),
                _ProfileFieldBox(
                  label: localizations.age,
                  value: age.toString(),
                  isEditing: isEditing,
                  controller: ageController,
                  type: TextInputType.number,
                ),
                _ProfileFieldBox(
                  label: localizations.birthday,
                  value: birthday,
                  isEditing: isEditing,
                  controller: birthdayController,
                ),
                _ProfileFieldBox(
                  label: localizations.school,
                  value: school,
                  isEditing: isEditing,
                  controller: schoolController,
                ),
                _ProfileFieldBox(
                  label: localizations.email,
                  value: email,
                  isEditing: isEditing,
                  controller: emailController,
                  type: TextInputType.emailAddress,
                ),
                _ProfileFieldBox(
                  label: localizations.phone,
                  value: phone,
                  isEditing: isEditing,
                  controller: phoneController,
                  type: TextInputType.phone,
                ),
                SizedBox(height: 24),
                isEditing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _saveProfile,
                            child: Text(localizations.save, style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(250, 57, 201, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _cancelEditing,
                            child: Text(localizations.cancel, style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(250, 57, 201, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _startEditing,
                            child: Text(localizations.editProfile, style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(250, 57, 201, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileFieldBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final TextInputType type;
  final bool isReadOnly;

  const _ProfileFieldBox({
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
    this.type = TextInputType.text,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Special styling for read-only username field
    bool isUsernameField = label == "Username" && isReadOnly;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isUsernameField ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: isUsernameField ? Border.all(color: Color.fromARGB(250, 57, 201, 245), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: (isEditing && !isReadOnly)
          ? TextFormField(
              controller: controller,
              keyboardType: type,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
            )
          : Row(
              children: [
                Text(
                  '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    color: isUsernameField ? Color.fromARGB(250, 57, 201, 245) : Colors.black87
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isUsernameField ? Color.fromARGB(250, 57, 201, 245) : Colors.black87,
                      fontWeight: isUsernameField ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isUsernameField)
                  Icon(
                    Icons.person_outline,
                    color: Color.fromARGB(250, 57, 201, 245),
                    size: 20,
                  ),
              ],
            ),
    );
  }
}
