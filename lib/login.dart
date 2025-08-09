import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
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
    return null;
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Login", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),)),
                        SizedBox(height: 20,),
                        FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Login to your account", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                        ),)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(duration: Duration(milliseconds: 1200), child: TextFormField(
                            controller: _emailController,
                            //validator: _emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          )),
                          SizedBox(height: 20),
                          FadeInUp(duration: Duration(milliseconds: 1300), child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            //validator: _passwordValidator,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                          )),
                        ],
                      ),
                    ),
                    FadeInUp(duration: Duration(milliseconds: 1400), child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
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
                          onPressed: _login,
                          color: Color.fromARGB(250, 57, 201, 245),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Text("Login", style: TextStyle(
                            fontWeight: FontWeight.w600, 
                            fontSize: 18
                          ),),
                        ),
                      ),
                    )),
                    FadeInUp(duration: Duration(milliseconds: 1500), child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text("Sign up", style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          )),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              // Removed background image container as per request
              // FadeInUp(duration: Duration(milliseconds: 1200), child: Container(
              //   height: MediaQuery.of(context).size.height / 3,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/background.png'),
              //       fit: BoxFit.cover
              //     )
              //   ),
              // ))
            ],
          ),
        ),
      ),
    );
  }
}
