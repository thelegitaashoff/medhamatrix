import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Recover Password', subtitle: 'We will help you reset your account access'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Password Help',
            subtitle: 'Enter your email address and we will send you the next recovery steps.',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MedhaTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  prefixIcon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                MedhaPrimaryButton(
                  label: 'Send Recovery Link',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recovery flow placeholder: connect your backend here.')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
