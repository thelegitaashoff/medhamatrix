
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

enum AppTheme { light, dark, system }

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  AppTheme _selectedTheme = AppTheme.system;

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
        final double fontSizeTitle = w(20);
        final double fontSize = w(16);
        final double buttonPaddingVertical = h(16);

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          appBar: AppBar(
            title: Text('Select Theme', style: TextStyle(fontSize: fontSizeTitle)),
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
                  boxShadow: const [
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose Your Preferred Theme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeTitle,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: verticalPadding),
                      RadioListTile<AppTheme>(
                        title: Text('Light Theme', style: TextStyle(fontSize: fontSize)),
                        value: AppTheme.light,
                        groupValue: _selectedTheme,
                        activeColor: Colors.teal,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                          // Update the app theme dynamically
                          switch (value) {
                            case AppTheme.light:
                              Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeMode.light);
                              break;
                            case AppTheme.dark:
                              Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeMode.dark);
                              break;
                            case AppTheme.system:
                              Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeMode.system);
                              break;
                            default:
                              // Handle null or unexpected values
                              Provider.of<ThemeNotifier>(context, listen: false).setTheme(ThemeMode.system);
                              break;
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: w(8)),
                      ),
                      RadioListTile<AppTheme>(
                        title: Text('Dark Theme', style: TextStyle(fontSize: fontSize)),
                        value: AppTheme.dark,
                        groupValue: _selectedTheme,
                        activeColor: Colors.teal,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: w(8)),
                      ),
                      RadioListTile<AppTheme>(
                        title: Text('System Default', style: TextStyle(fontSize: fontSize)),
                        value: AppTheme.system,
                        groupValue: _selectedTheme,
                        activeColor: Colors.teal,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: w(8)),
                      ),
                      SizedBox(height: verticalPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your save logic here, e.g., saving theme preference
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Theme set to ${_selectedTheme.name}')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 224, 248, 255),
                            padding: EdgeInsets.symmetric(vertical: buttonPaddingVertical),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: fontSize, letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
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
  