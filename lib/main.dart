import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medhamatrix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'about.dart';
import 'agora_call_page.dart';
import 'certificate_download.dart';
import 'counselling.dart';
import 'counseling_sessions_page.dart';
import 'dashboard.dart';
import 'gallery.dart';
import 'login.dart';
import 'medha_ui.dart';
import 'notifications.dart';
import 'offers.dart';
import 'password_recovery_screen.dart';
import 'payment.dart';
import 'phonepe_api_test.dart';
import 'profile.dart';
import 'settings.dart';
import 'signup.dart';
import 'splash_screen.dart';
import 'team_page.dart';
import 'test.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'RobotoSlab',
      scaffoldBackgroundColor: MedhaColors.page,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MedhaColors.primary,
        primary: MedhaColors.primary,
        surface: MedhaColors.page,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: MedhaColors.muted),
        labelStyle: const TextStyle(color: MedhaColors.text),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: MedhaColors.border),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: MedhaColors.text),
        bodyMedium: TextStyle(color: MedhaColors.text),
        titleLarge: TextStyle(color: MedhaColors.text),
      ),
    );

    return MaterialApp(
      title: 'Medhamatrix',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      darkTheme: baseTheme,
      themeMode: themeNotifier.themeMode,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('mr')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (_) => const SplashScreen();
            break;
          case '/login':
            builder = (_) => const LoginPage();
            break;
          case '/signup':
            builder = (_) => const SignupPage();
            break;
          case '/our_team':
          case '/team':
            builder = (_) => TeamPage();
            break;
          case '/password_recovery':
            builder = (_) => PasswordRecoveryScreen();
            break;
          case '/dashboard':
            builder = (_) => const Dashboard();
            break;
          case '/test':
            builder = (_) => const TestSelectionPage();
            break;
          case '/counselling':
            builder = (_) => const CounselingSelectionPage();
            break;
          case '/profile':
            builder = (_) => const EditableProfilePage();
            break;
          case '/settings':
            builder = (_) => const SettingsPage(userName: 'Ashish awhale');
            break;
          case '/payment_history':
            builder = (_) => const GalleryPage();
            break;
          case '/payment':
            builder = (_) => const PaymentPage();
            break;
          case '/notifications':
            builder = (_) => const NotificationSettingsPage();
            break;
          case '/offers':
            builder = (_) => OffersPage();
            break;
          case '/about':
            builder = (_) => const AboutUsMedhaMatrixPage();
            break;
          case '/agora_call':
            builder = (_) => const AgoraCallPage();
            break;
          case '/certificate_download':
            builder = (_) => CertificateDownloadPage();
            break;
          case '/counseling_sessions':
            builder = (_) => const CounselingSessionsPage();
            break;
          case '/phonepe_test':
            builder = (_) => const PhonePeApiTest();
            break;
          default:
            builder = (_) => const Dashboard();
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 280),
          settings: settings,
        );
      },
    );
  }
}
