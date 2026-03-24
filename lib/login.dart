import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';
import 'package:medhamatrix/models/login_request.dart';
import 'package:medhamatrix/services/api_service.dart';
import 'package:medhamatrix/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Please enter a valid email address';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters long';
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final hasInternet = await ApiService.checkInternetConnection();
      if (!hasInternet) {
        _showSnack('No internet connection. Please check your network and try again.', isError: true);
        return;
      }

      final response = await ApiService.login(
        LoginRequest(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        ),
      );

      if (response.success) {
        if (response.data != null) {
          final token = response.data!['access_token'] ?? response.data!['token'] ?? response.data!['access'];
          if (token != null) {
            await UserService.setAuthToken(token);
          }
          await UserService.initialize();
        }
        if (!mounted) return;
        _showSnack(response.message ?? 'Login successful');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showSnack(response.message ?? 'Login failed', isError: true);
      }
    } catch (_) {
      _showSnack('Login failed. Please try again.', isError: true);
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: ''),
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
                      MedhaIconTile(icon: Icons.lock_outline_rounded, size: 68),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MedhaColors.text),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Login to continue your learning journey',
                              style: TextStyle(fontSize: 15, color: MedhaColors.muted, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
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
                    hint: 'Enter your password',
                    prefixIcon: Icons.password_rounded,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/password_recovery'),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: MedhaColors.primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MedhaPrimaryButton(
                    label: _isLoading ? 'Logging In...' : 'Login',
                    onPressed: _isLoading ? null : _login,
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: MedhaColors.text),
                    ),
                  ),
                  const SizedBox(height: 12),
                  MedhaOutlineButton(
                    label: 'Create One',
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
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
