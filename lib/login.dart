import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:medhamatrix/services/api_service.dart';
import 'package:medhamatrix/services/user_service.dart';
import 'package:medhamatrix/models/login_request.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // More comprehensive email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    // Additional password strength validation
    if (!RegExp(r'^(?=.*[a-zA-Z])').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    return null;
  }

  Future<void> _login() async {
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

        final loginRequest = LoginRequest(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );

        print('Attempting login with email: ${loginRequest.email}');
        final response = await ApiService.login(loginRequest);

        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Login successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Store login data (tokens, user info, etc.)
          if (response.data != null) {
            print('Login response data: ${response.data}');
            
            // Store auth token if available
            final token = response.data!['access_token'] ?? response.data!['token'] ?? response.data!['access'];
            if (token != null) {
              await UserService.setAuthToken(token);
              print('Auth token stored: ${token.toString().substring(0, 20)}...');
            }
            
            // Initialize user service
            await UserService.initialize();
          }
          
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Login failed'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'Login failed: ${e.toString()}';
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Network error: Please check your internet connection and try again.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timeout: Please check your connection and try again.';
        } else if (e.toString().contains('FormatException')) {
          errorMessage = 'Server error: Invalid response format.';
        }
        
        print('Login error: $e');
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
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
                    FadeInUp(duration: Duration(milliseconds: 400), child: Text("Login", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),)),
                    SizedBox(height: 5),
                    FadeInUp(duration: Duration(milliseconds: 400), child: Text("Welcome back, please login to continue", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                    ),)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(duration: Duration(milliseconds: 400), child: makeInput(controller: _emailController, label: "Email", validator: _emailValidator)),
                    FadeInUp(duration: Duration(milliseconds: 400), child: makeInput(controller: _passwordController, label: "Password", obscureText: true, validator: _passwordValidator)),
                  ],
                ),
                FadeInUp(duration: Duration(milliseconds: 400), child: Container(
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
                    onPressed: _isLoading ? null : _login,
                    color: Color.fromARGB(250, 57, 201, 245),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Login", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        )),
                  ),
                )),
                FadeInUp(duration: Duration(milliseconds: 400), child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(" Sign up", style: TextStyle(
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
