import 'package:flutter/material.dart';
import 'test.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'payment.dart';
import 'offers.dart';
import 'about.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restored App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Dashboard(),
        '/test': (context) => const TestPage(),
        '/counselling': (context) => const CounsellingPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/payment': (context) => const PaymentPage(),
        '/offers': (context) => const OffersPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
