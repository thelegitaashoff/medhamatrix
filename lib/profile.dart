import 'package:flutter/material.dart';
import 'dashboard.dart';

class EditableProfilePage extends StatefulWidget {
  final bool startEditing;

  EditableProfilePage({this.startEditing = false});

  @override
  State<EditableProfilePage> createState() => _EditableProfilePageState();
}

class _EditableProfilePageState extends State<EditableProfilePage> {
  bool isEditing = false;

  // Profile data
  String name = 'Emily Clark';
  int age = 24;
  String birthday = '08/12/2000';
  String school = 'Maplewood High School';
  String email = 'emily.clark@email.com';
  String phone = '+1 234 567 8910';

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
    if (widget.startEditing) {
      _startEditing();
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

  void _saveProfile() {
    setState(() {
      name = nameController.text;
      age = int.tryParse(ageController.text) ?? age;
      birthday = birthdayController.text;
      school = schoolController.text;
      email = emailController.text;
      phone = phoneController.text;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  label: "Name",
                  value: name,
                  isEditing: isEditing,
                  controller: nameController,
                ),
                _ProfileFieldBox(
                  label: "Age",
                  value: age.toString(),
                  isEditing: isEditing,
                  controller: ageController,
                  type: TextInputType.number,
                ),
                _ProfileFieldBox(
                  label: "Birthday",
                  value: birthday,
                  isEditing: isEditing,
                  controller: birthdayController,
                ),
                _ProfileFieldBox(
                  label: "School",
                  value: school,
                  isEditing: isEditing,
                  controller: schoolController,
                ),
                _ProfileFieldBox(
                  label: "Email",
                  value: email,
                  isEditing: isEditing,
                  controller: emailController,
                  type: TextInputType.emailAddress,
                ),
                _ProfileFieldBox(
                  label: "Phone",
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
                            child: Text('Save', style: TextStyle(color: Colors.white)),
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
                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
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
                            child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
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

  const _ProfileFieldBox({
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: isEditing
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
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
    );
  }
}
