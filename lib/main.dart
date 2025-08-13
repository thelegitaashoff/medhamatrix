import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medhamatrix/l10n/app_localizations.dart';

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
import 'certificate_download.dart';
import 'splash_screen.dart';
import 'phonepe_api_test.dart';

import 'package:provider/provider.dart';
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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Medhamatrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Times New Roman',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black54),
          floatingLabelStyle: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Times New Roman',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white70),
          floatingLabelStyle: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeNotifier.themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => const SplashScreen();
            break;
          case '/login':
            builder = (BuildContext _) => LoginPage();
            break;
          case '/signup':
            builder = (BuildContext _) => SignupPage();
            break;
          case '/our_team':
            builder = (BuildContext _) => TeamPage();
            break;
          case '/password_recovery':
            builder = (BuildContext _) => PasswordRecoveryScreen();
            break;
          case '/dashboard':
            builder = (BuildContext _) =>  Dashboard();
            break;
          case '/test':
            builder = (BuildContext _) => TestSelectionPage();
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
             builder = (BuildContext _) =>  NotificationSettingsPage();
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
          case '/certificate_download':
            builder = (BuildContext _) => CertificateDownloadPage();
            break;
          case '/phonepe_test':
            builder = (BuildContext _) => const PhonePeApiTest();
            break;
          default:
            builder = (BuildContext _) =>  Dashboard();
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
