import 'package:flutter/material.dart';
import 'test.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'payment.dart';
import 'offers.dart';
import 'about.dart';
import 'dashboard.dart';
import 'notifications.dart';
import 'payment_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medhamatrics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Times New Roman',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => const Dashboard();
            break;
          case '/test':
            builder = (BuildContext _) => const TestPage();
            break;
          case '/counselling':
            builder = (BuildContext _) => const CounsellingPage();
            break;
          case '/profile':
            builder = (BuildContext _) => const ProfilePage();
            break;
          case '/settings':
            builder = (BuildContext _) => const SettingsPage();
            break;
          case '/payment_history':
            builder = (BuildContext _) => const PaymentHistoryPage();
            break;
          case '/payment':
            builder = (BuildContext _) => const PaymentPage();
            break;
          case '/notifications':
            builder = (BuildContext _) => const NotificationPage();
            break;
          case '/offers':
            builder = (BuildContext _) => const OffersPage();
            break;
          case '/about':
            builder = (BuildContext _) => const AboutPage();
            break;
          default:
            builder = (BuildContext _) => const Dashboard();
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 350),
          settings: settings,
        );
      },
    );
  }
}
