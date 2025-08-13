import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLang = 'English';

  final List<String> _languages = [
    'English',
    'Hindi',
    'Marathi',
  ];

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
            title: Text('Select Language', style: TextStyle(fontSize: fontSizeTitle)),
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
                        'Choose your preferred language',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeTitle,
                        ),
                      ),
                      SizedBox(height: verticalPadding),
                      ..._languages.map(
                        (lang) => RadioListTile<String>(
                          value: lang,
                          groupValue: _selectedLang,
                          activeColor: Colors.teal,
                          title: Text(
                            lang == 'Marathi' ? 'मराठी (Marathi)' : lang,
                            style: TextStyle(fontSize: fontSize),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: w(8)),
                          onChanged: (value) {
                            setState(() {
                              _selectedLang = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: verticalPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: buttonPaddingVertical),
                            backgroundColor: const Color.fromARGB(255, 224, 248, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Save the selected language (add your save logic here)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Language set to $_selectedLang')),
                            );
                          },
                          child: Text(
                            'Save',
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
        );
      },
    );
  }
}
