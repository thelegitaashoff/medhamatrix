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
import 'gallery.dart';
import 'team_page.dart';
import 'login.dart';
import 'signup.dart';
import 'password_recovery_screen.dart';

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
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/login':
            builder = (BuildContext _) => LoginPage();
            break;
          case '/signup':
            builder = (BuildContext _) => SignupPage();
            break;
          case '/password_recovery':
            builder = (BuildContext _) => PasswordRecoveryScreen();
            break;
          case '/dashboard':
          case '/':
            builder = (BuildContext _) => const Dashboard();
            break;
          case '/test':
            builder = (BuildContext _) => TestPage();
            break;
          case '/counselling':
            builder = (BuildContext _) => CounselingSelectionPage();
            break;
          case '/profile':
            builder = (BuildContext _) =>  EditableProfilePage();
            break;
          case '/settings':
            builder = (BuildContext _) => SettingsPage(userName: "Therese Webb");
            break;
          case '/payment_history':
            builder = (BuildContext _) => const GalleryPage();
            break;
          case '/payment':
            builder = (BuildContext _) => const PaymentPage();
            break;
          case '/notifications':
            builder = (BuildContext _) =>  NotificationsPage();
            break;
          case '/offers':
            builder = (BuildContext _) => OffersPage();
            break;
          case '/about':
            builder = (BuildContext _) =>  AboutUsMedhaMatrixPage();
            break;
          case '/team':
            builder = (BuildContext _) => TeamPage();
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
