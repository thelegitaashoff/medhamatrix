import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:medhamatrix/services/api_service.dart';
import 'package:medhamatrix/models/signup_request.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _birthdayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your birthday';
    }
    return null;
  }


  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    // Remove any non-digit characters for validation
    String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 10 || cleaned.length > 15) {
      return 'Please enter a valid mobile number (10-15 digits)';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    _password = value;
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check internet connectivity first
        bool hasInternet = await ApiService.checkInternetConnection();
        if (!hasInternet) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No internet connection. Please check your network and try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
          return;
        }

        final signupRequest = SignupRequest(
          fullName: _nameController.text.trim(),
          dob: _birthdayController.text.trim(),
          mobile: _phoneController.text.trim(),
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
          role: 'student', // Fixed role as student
        );

        print('Attempting registration with data: ${signupRequest.toJson()}');
        final response = await ApiService.signup(signupRequest);

        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Registration successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Clear form
          _nameController.clear();
          _birthdayController.clear();
          _phoneController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Registration failed'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'Registration failed: ${e.toString()}';
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Network error: Please check your internet connection and try again.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timeout: Please check your connection and try again.';
        } else if (e.toString().contains('FormatException')) {
          errorMessage = 'Server error: Invalid response format.';
        }
        
        print('Registration error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 224, 248, 255),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 400), child: Text("Registration", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),)),
                  SizedBox(height: 5,),
                  FadeInUp(duration: Duration(milliseconds: 400), child: Text("Create an account, It's free", style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700]
                  ),)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(duration: Duration(milliseconds: 400), child: makeInput(controller: _nameController, label: "Full Name", validator: _nameValidator)),
                    FadeInUp(
                      duration: Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date of Birth", style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          )),

                          SizedBox(height: 5),
                          TextFormField(
                            controller: _birthdayController,
                            readOnly: true,
                            validator: _birthdayValidator,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400)
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400)
                              ),
                            ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    _birthdayController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                    
                    FadeInUp(duration: Duration(milliseconds: 1350), child: makeInput(controller: _phoneController, label: "Mobile Number", validator: _phoneValidator)),
                    FadeInUp(duration: Duration(milliseconds: 1400), child: makeInput(controller: _emailController, label: "Email", validator: _emailValidator)),
                    FadeInUp(duration: Duration(milliseconds: 1450), child: makeInput(controller: _passwordController, label: "Password", obscureText: true, validator: _passwordValidator)),
                    FadeInUp(duration: Duration(milliseconds: 1500), child: makeInput(controller: _confirmPasswordController, label: "Confirm Password", obscureText: true, validator: _confirmPasswordValidator)),
                  ],
                ),
                FadeInUp(duration: Duration(milliseconds: 1500), child: Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: _isLoading ? null : _register,
                    color: Color.fromARGB(250, 57, 201, 245),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Register", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        )),
                  ),
                )),
                FadeInUp(duration: Duration(milliseconds: 1600), child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(" Login", style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false, String? Function(String?)? validator, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)
            ),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }
}
