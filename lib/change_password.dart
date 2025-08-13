import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  bool _newPwdObscure = true;
  bool _oldPwdObscure = true;
  bool _confirmPwdObscure = true;

  @override
  void dispose() {
    _oldPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Write your password change logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully!')),
      );
      _oldPwdController.clear();
      _newPwdController.clear();
      _confirmPwdController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool isTablet = width > 700;
        bool isWide = width > 1100;

        // Responsive scaling functions
        double h(double val) => height * val / 817;
        double w(double val) => width * val / 400;

        final double horizontalPadding = isWide
            ? w(40)
            : isTablet
                ? w(20)
                : w(10);
        final double verticalPadding = h(15);
        final double containerPadding = w(16);
        final double containerMargin = h(15);
        final double fontSize = w(18);

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          appBar: AppBar(
            title: Text('Change Password', style: TextStyle(fontSize: fontSize)),
            backgroundColor: const Color.fromARGB(255, 224, 248, 255),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 1000 : double.infinity),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerPadding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(containerPadding),
                margin: EdgeInsets.only(bottom: containerMargin),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Old Password
                        TextFormField(
                          controller: _oldPwdController,
                          obscureText: _oldPwdObscure,
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _oldPwdObscure ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _oldPwdObscure = !_oldPwdObscure;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter old password';
                            return null;
                          },
                        ),
                        SizedBox(height: verticalPadding),
                        // New Password
                        TextFormField(
                          controller: _newPwdController,
                          obscureText: _newPwdObscure,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _newPwdObscure ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _newPwdObscure = !_newPwdObscure;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter new password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        SizedBox(height: verticalPadding),
                        // Confirm Password
                        TextFormField(
                          controller: _confirmPwdController,
                          obscureText: _confirmPwdObscure,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPwdObscure ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPwdObscure = !_confirmPwdObscure;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Confirm new password';
                            if (value != _newPwdController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        SizedBox(height: verticalPadding * 2),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: verticalPadding),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: const Color.fromARGB(255, 224, 248, 255),
                            ),
                            onPressed: _changePassword,
                            child: Text(
                              'Change Password',
                              style: TextStyle(fontSize: fontSize, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
