import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';
import 'package:medhamatrix/models/signup_request.dart';
import 'package:medhamatrix/services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  String _password = '';

  String? _nameValidator(String? value) => value == null || value.trim().isEmpty ? 'Please enter your full name' : null;
  String? _birthdayValidator(String? value) => value == null || value.isEmpty ? 'Please select your date of birth' : null;

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your mobile number';
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 10 || cleaned.length > 15) return 'Please enter a valid mobile number';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    _password = value;
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _password) return 'Passwords do not match';
    return null;
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _birthdayController.text =
          '${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final hasInternet = await ApiService.checkInternetConnection();
      if (!hasInternet) {
        _showSnack('No internet connection. Please check your network and try again.', isError: true);
        return;
      }

      final response = await ApiService.signup(
        SignupRequest(
          fullName: _nameController.text.trim(),
          dob: _birthdayController.text.trim(),
          mobile: _phoneController.text.trim(),
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
          role: 'student',
        ),
      );

      if (response.success) {
        _showSnack(response.message ?? 'Registration successful');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showSnack(response.message ?? 'Registration failed', isError: true);
      }
    } catch (_) {
      _showSnack('Registration failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? MedhaColors.danger : MedhaColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      child: MedhaPageView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          MedhaCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      MedhaIconTile(icon: Icons.person_add_alt_1_rounded, size: 68),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MedhaColors.text),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Sign up to start your MedhaMatrix journey',
                              style: TextStyle(fontSize: 15, color: MedhaColors.muted, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  MedhaTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.badge_outlined,
                    validator: _nameValidator,
                  ),
                  MedhaTextField(
                    controller: _birthdayController,
                    label: 'Date of Birth',
                    hint: 'YYYY-MM-DD',
                    prefixIcon: Icons.cake_outlined,
                    validator: _birthdayValidator,
                    onTap: _selectDate,
                    readOnly: true,
                  ),
                  MedhaTextField(
                    controller: _phoneController,
                    label: 'Mobile Number',
                    hint: 'Enter mobile number',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: _phoneValidator,
                  ),
                  MedhaTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@example.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),
                  MedhaTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _hidePassword,
                    validator: _passwordValidator,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: MedhaColors.muted,
                      ),
                    ),
                  ),
                  MedhaTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Re-enter password',
                    prefixIcon: Icons.verified_user_outlined,
                    obscureText: _hideConfirmPassword,
                    validator: _confirmPasswordValidator,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hideConfirmPassword = !_hideConfirmPassword),
                      icon: Icon(
                        _hideConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: MedhaColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  MedhaPrimaryButton(
                    label: _isLoading ? 'Registering...' : 'Register',
                    onPressed: _isLoading ? null : _register,
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: MedhaColors.text),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: MedhaColors.primary, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
