import 'package:flutter/material.dart';
import 'profile.dart';
import 'payment.dart';

class TestSelectionPage extends StatefulWidget {
  const TestSelectionPage({super.key});

  @override
  State<TestSelectionPage> createState() => _TestSelectionPageState();
}

class _TestSelectionPageState extends State<TestSelectionPage> {
  final List<Map<String, dynamic>> tests = [
    {
      'title': 'IQ Test',
      'subtitle': 'Assess your logical intelligence',
      'icon': Icons.lightbulb_outline,
      'instructions': '• Read each question carefully.\n• There is no time limit.\n• No calculators allowed.\n• Answer honestly for best results.',
    },
    {
      'title': 'Depression Scale',
      'subtitle': 'Evaluate your emotional well-being',
      'icon': Icons.sentiment_dissatisfied,
      'instructions': '• Answer honestly based on your feelings.\n• There are no right or wrong answers.\n• This helps understand your emotional state.',
    },
    {
      'title': 'EQ',
      'subtitle': 'Measure your emotional intelligence',
      'icon': Icons.favorite,
      'instructions': '• Reflect on your emotional responses.\n• Answer all questions sincerely.\n• Helps in understanding your emotional skills.',
    },
    {
      'title': 'REBT',
      'subtitle': 'Rational Emotive Behavior Therapy assessment',
      'icon': Icons.psychology,
      'instructions': '• Focus on your thought patterns.\n• Answer based on your typical reactions.\n• Aids in cognitive behavioral understanding.',
    },
    {
      'title': 'CBT',
      'subtitle': 'Cognitive Behavioral Therapy assessment',
      'icon': Icons.self_improvement,
      'instructions': '• Consider your behaviors and thoughts.\n• Answer honestly for accurate results.\n• Helps in identifying behavioral patterns.',
    },
  ];

  final Color iconColor = const Color.fromARGB(250, 57, 201, 245);

  int _selectedIndex = 0;

 void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditableProfilePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: tests.map((test) {
            return Container(
              margin: EdgeInsets.only(bottom: 18),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white, // Box color white
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 5),
                  )
                ],
                border: Border.all(color: Colors.grey[200]!, width: 0.7),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 224, 248, 255), // Icon background white
                    child: Icon(test['icon'], color: iconColor, size: 28), // Icon color as specified
                    radius: 28,
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black text
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          test['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black, // Black text
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          title: Text(
                            'Pre-Exam Instructions',
                            style: TextStyle(color: Colors.black),
                          ),
                          content: Text(
                            test['instructions'],
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel', style: TextStyle(color: iconColor)),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 224, 248, 255),
                              ),
                              child: Text('Proceed', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => PaymentPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor, // 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Start", style: TextStyle(color: Color.fromARGB(255, 224, 248, 255),)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
