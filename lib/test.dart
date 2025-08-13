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

  // Removed duplicate declarations of _iqConsent variables to fix redeclaration errors

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

  void _showCBTQuestionDialog(BuildContext context, int questionIndex) {
    final List<String> cbtQuestions = [
      '📲 What is a CBT Test?\nThe CBT Test is a self-assessment tool.\n\nThrough this test, you can better understand the patterns in your thoughts, emotions, and behaviors.\n\nThis test helps identify issues like stress, anxiety, depression, low self-confidence, and negative thinking patterns.\n\n',
      '📌 Why Should You Take the CBT Test?\nThis test is useful for the following reasons:\n\n✅ Increases awareness of your thought patterns\n✅ Helps identify negative thoughts\n✅ Explains how your emotions influence your behavior\n✅ Helps you recognize early signs of stress, depression, and anxiety\n✅ Helps you determine whether you might benefit from CBT counseling\n\n',
      '🧾 What Happens After Taking the CBT Test?\nBased on your test results, you’ll gain clarity on:\n\n🔸 Do you need to change your thought patterns?\n🔸 Do you need counseling or therapy?\n\nIf your thought patterns show significant negativity, a trained counselor can conduct CBT therapy sessions with you.\n\n',
      '📌 Who Can Benefit from CBT Therapy?\nCBT therapy is helpful for individuals dealing with:\n\n🔹 Anxiety, fear, nervousness\n🔹 Depression\n🔹 Inferiority complex, low self-confidence\n🔹 Negative self-perception\n🔹 Constant negative thinking\n🔹 OCD, phobia, PTSD, etc.\n\nNote: This CBT test is',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'CBT Test Question ${questionIndex + 1}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            cbtQuestions[questionIndex],
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Skip', style: TextStyle(color: Color.fromARGB(250, 57, 201, 245))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 224, 248, 255),
            ),
            child: Text(questionIndex == cbtQuestions.length - 1 ? 'Finish' : 'Next', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              if (questionIndex < cbtQuestions.length - 1) {
                _showCBTQuestionDialog(context, questionIndex + 1);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showREBTQuestionDialog(BuildContext context, int questionIndex) {
    final List<String> rebtQuestions = [
      ' 🧠 What is REBT?\nREBT stands for Rational Emotive Behavior Therapy – a scientific method that identifies irrational, self-destructive, or negative thought patterns and teaches logical and positive thinking.',
      '📋 What is the REBT Test?\nThis test evaluates your patterns of thinking, emotions, and behavior.\nIt\'s a way to understand whether your thoughts empower you or drag you down.',
      ' ❓ Why take this test?\n✅ To identify negative thinking\n✅ To learn how to cope with stress, anger, and frustration\n✅ To boost self-confidence\n✅ For counseling or personal development',
      ' 👤 Who can take this test?\n🧒 Students aged 12 and above\n👩‍🏫 Parents and teachers\n🧑‍⚕️ Counselors\nAnyone who wants to understand their mental state and thought patterns',
      ' ✨ REBT Test – A Mirror to the Mind\nThis test is very useful for logically examining your own emotions and thoughts.',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'REBT Test Question ${questionIndex + 1}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            rebtQuestions[questionIndex],
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Skip', style: TextStyle(color: Color.fromARGB(250, 57, 201, 245))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 224, 248, 255),
            ),
            child: Text(questionIndex == rebtQuestions.length - 1 ? 'Finish' : 'Next', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              if (questionIndex < rebtQuestions.length - 1) {
                _showREBTQuestionDialog(context, questionIndex + 1);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDepressionQuestionDialog(BuildContext context, int questionIndex) {
final List<String> depressionQuestions = [
      'What is the Depression Scale?\nThe Depression Scale is a psychological test used to assess mental health. It helps determine whether a person is suffering from depression and to what extent.',
      'Purpose of the Depression Scale:\n\n- To identify whether a person has symptoms of depression\n- To determine the severity of depression — mild, moderate, or severe\n- To measure changes before and after treatment\n- To guide mental health counselors and psychiatrists in their evaluations',
      'When should the Depression Scale be used?\n\n- When a person constantly feels sad or low\n- If there are changes in sleep, appetite, or mood\n- When there\'s a lack of interest in studies/work\n- If there are thoughts of self-harm or suicide',
      'Who can use it?\n\n- Psychiatrists\n- Counselors\n- Doctors\n- Trained mental health professionals',
      'Important Note:\nThis scale is a supportive tool, not a definitive diagnostic test. If a person scores high, they should consult a professional mental health expert.',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Depression Scale Test Question ${questionIndex + 1}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            depressionQuestions[questionIndex],
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Skip', style: TextStyle(color: Color.fromARGB(250, 57, 201, 245))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 224, 248, 255),
            ),
            child: Text(questionIndex == depressionQuestions.length - 1 ? 'Finish' : 'Next', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
              if (questionIndex < depressionQuestions.length - 1) {
                _showDepressionQuestionDialog(context, questionIndex + 1);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Removed duplicate _showDepressionScaleInfoDialog method to fix redeclaration error

  void _showDepressionScaleInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'What is the Depression Scale?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('The Depression Scale is a psychological test used to assess mental health. It helps determine whether a person is suffering from depression and to what extent.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('Purpose of the Depression Scale:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 6),
              Text('• To identify whether a person has symptoms of depression', style: TextStyle(color: Colors.black)),
              Text('• To determine the severity of depression — mild, moderate, or severe', style: TextStyle(color: Colors.black)),
              Text('• To measure changes before and after treatment', style: TextStyle(color: Colors.black)),
              Text('• To guide mental health counselors and psychiatrists in their evaluations', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('When should the Depression Scale be used?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 6),
              Text('• When a person constantly feels sad or low', style: TextStyle(color: Colors.black)),
              Text('• If there are changes in sleep, appetite, or mood', style: TextStyle(color: Colors.black)),
              Text('• When there\'s a lack of interest in studies/work', style: TextStyle(color: Colors.black)),
              Text('• If there are thoughts of self-harm or suicide', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('Who can use it?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 6),
              Text('• Psychiatrists', style: TextStyle(color: Colors.black)),
              Text('• Counselors', style: TextStyle(color: Colors.black)),
              Text('• Doctors', style: TextStyle(color: Colors.black)),
              Text('• Trained mental health professionals', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('Important Note:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 6),
              Text('This scale is a supportive tool, not a definitive diagnostic test. If a person scores high, they should consult a professional mental health expert.', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close', style: TextStyle(color: Color.fromARGB(250, 57, 201, 245))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  bool _iqConsent1 = false;
  bool _iqConsent2 = false;
  bool _iqConsent3 = false;
  bool _iqConsent4 = false;

  bool _iqConsentAgree = false;

  void _showIQTestConsentDialog(BuildContext context) {
    _iqConsentAgree = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Parental consent', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('I am giving my consent for the Medha Matrix IQ test as per the following terms.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(height: 10),
                    Text('This test is conducted solely to assess the student\'s intellectual ability.', style: TextStyle(color: Colors.black)),
                    SizedBox(height: 10),
                    Text('The test results will be used to guide the student and parents. They may be used for academic or career counseling purposes.', style: TextStyle(color: Colors.black)),
                    SizedBox(height: 10),
                    Text('We are participating in this test completely voluntarily, without any compulsion.', style: TextStyle(color: Colors.black)),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('I agree', style: TextStyle(color: Colors.black)),
                      value: _iqConsentAgree,
                      onChanged: (bool? value) {
                        setState(() {
                          _iqConsentAgree = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: iconColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: _iqConsentAgree
                      ? () {
                          Navigator.of(context).pop();
                          _showIQTestInstructionsDialog(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _iqConsentAgree ? iconColor : Colors.grey,
                  ),
                  child: Text('Proceed', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showIQTestInstructionsDialog(BuildContext context) {
    final iqTest = tests.firstWhere((test) => test['title'] == 'IQ Test', orElse: () => {});
    final instructions = iqTest.isNotEmpty ? iqTest['instructions'] as String : 'No instructions available.';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('IQ Test Instructions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(instructions, style: TextStyle(color: Colors.black)),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: iconColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
              ),
              child: Text('Proceed', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showIQTestInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'IQ Test Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What is IQ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              SizedBox(height: 4),
              Text('IQ stands for "Intelligence Quotient." It is a standardized test metric that measures a person\'s intelligence, reasoning ability, memory, analytical skills, and problem-solving capacity.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('An "IQ Test" is an assessment that evaluates a student’s thinking ability, reasoning power, and memory. With the help of this test, one can estimate their intellectual capacity. As a result, it helps in providing proper educational guidance, modifying study methods, and forming a clear career selection strategy. This test is useful for identifying gifted students as well as helping students with special needs.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('Importance of the IQ Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              SizedBox(height: 8),
              Text('Identifying Intellectual Ability:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('An IQ test helps assess a person\'s thinking ability, understanding, analysis, and problem-solving skills. It helps identify the level of intelligence of the individual.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Getting the Right Guidance:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('The IQ test assists students, parents, and teachers in providing appropriate educational and career guidance. Based on IQ levels, suitable career choices can be made.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Understanding Learning Style and Speed:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('The IQ test helps determine whether a student learns quickly or slowly and what kind of teaching methods would be most effective—this benefits both teachers and parents.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Identifying Gifted or Special Needs Students:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('IQ testing helps promote students with high intelligence to the next level and also identifies those with lower scores who may need special support.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Improving Decision-Making, Thinking Style, and Logical Abilities:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('IQ tests examine various aspects of thinking, which help develop logical reasoning, observation skills, and the ability to find solutions to problems.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Preparation for Competitive Exams:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('Many competitive exams include IQ or Mental Ability questions. Taking IQ tests helps students become familiar with such question formats.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Helping Teachers and Parents Make the Right Decisions:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('Based on the IQ report, teachers and parents can identify learning difficulties, track academic progress, and decide the right direction for the child’s education.', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close', style: TextStyle(color: iconColor)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding = constraints.maxWidth * 0.04;
          double verticalPadding = constraints.maxHeight * 0.02;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              children: tests.map((test) {
                return Container(
                  margin: EdgeInsets.only(bottom: verticalPadding * 2),
                  padding: EdgeInsets.all(horizontalPadding),
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
                      SizedBox(width: horizontalPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              test['title'],
                              style: TextStyle(
                                fontSize: horizontalPadding * 1.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Black text
                              ),
                            ),
                            SizedBox(height: verticalPadding / 2),
                            Text(
                              test['subtitle'],
                              style: TextStyle(
                                fontSize: horizontalPadding,
                                color: Colors.black, // Black text
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (test['title'] == 'CBT') {
                                _showCBTQuestionDialog(context, 0);
                              } else if (test['title'] == 'REBT') {
                                _showREBTQuestionDialog(context, 0);
                              } else if (test['title'] == 'Depression Scale') {
                                _showDepressionQuestionDialog(context, 0);
                              } else if (test['title'] == 'IQ Test') {
                                _showIQTestConsentDialog(context);
                              } else {
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
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: iconColor, //
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text("Start", style: TextStyle(color: Color.fromARGB(255, 224, 248, 255),)),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (test['title'] == 'REBT') {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'REBT Test Information',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('What is the REBT Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The REBT Test is a psychological assessment that identifies irrational or unrealistic elements in a person\'s thinking, emotions, and behavior.\nIt is based on the principles of Rational Emotive Behavior Therapy (REBT), developed by renowned psychotherapist Dr. Albert Ellis.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('REBT holds the belief that:', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('"It’s not the events themselves that disturb us, but the way we think about those events."', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
                                          SizedBox(height: 12),
                                          Text('Main Objectives of the REBT Test:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('To identify a person\'s irrational or unrealistic beliefs\n\nTo recognize the emotional distress or behavioral issues caused by those beliefs\n\nTo help the individual replace faulty thinking with rational thoughts and promote positive behavior', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Who is this test useful for?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Students aged 12 and above\n\nYouth and adults experiencing stress, anxiety, or self-confidence issues\n\nTeachers/Parents seeking to understand students’ mental health\n\nCounselors/Therapists for initial evaluation before starting therapy', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Why take the REBT Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('✅ Increases awareness of negative thought patterns\n✅ Helps develop emotional balance and logical thinking\n✅ Helps correct irrational beliefs\n✅ Boosts self-confidence and self-control', style: TextStyle(color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Close', style: TextStyle(color: iconColor)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (test['title'] == 'EQ') {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'EQ Test Information',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('What is the EQ Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The EQ Test is a psychological assessment that measures a person\'s Emotional Intelligence (EQ).\nThis type of intelligence enables us to recognize, understand, regulate, and respond appropriately to our own emotions and those of others.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Components of EQ (Emotional Quotient):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('According to Daniel Goleman, EQ consists of five main components:', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Self-awareness - Recognizing your own emotions:\nUnderstanding how you\'re feeling at the moment.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Self-regulation - Managing emotions like anger, stress, and anxiety:\nKeeping emotional reactions under control.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Motivation - Staying self-motivated to achieve goals.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Empathy - Understanding and being sensitive to the emotions of others.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Social Skills - Maintaining healthy relationships and effective communication with others.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Why should you take the EQ Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('✅ To better understand yourself\n✅ To improve emotional regulation\n✅ To enhance personal and professional relationships\n✅ For leadership development and teamwork\n✅ For guidance of students, teachers, and counselors\n✅ To support and maintain mental well-being', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('What does the EQ Test include?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The EQ Test contains a series of questions based on your emotions, reactions, and social interactions.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Who can take the EQ Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('Students (from age 10 and above)\n\nTeachers and Parents\n\nYouth and Adults\n\nMental health professionals\n\nEmployees in organizations', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Conclusion:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The EQ Test is not just an assessment - it\'s a tool for emotional understanding, social skill-building, and self-development.\nIn today\'s world, EQ is considered just as important as IQ!', style: TextStyle(color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Close', style: TextStyle(color: iconColor)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (test['title'] == 'CBT') {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'CBT Test Information',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('What is CBT?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('CBT stands for Cognitive Behavioral Therapy – an effective and scientific form of psychotherapy that explains the relationship between our thoughts (Cognitive), emotions (Emotions), and behaviors (Behavior).', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 8),
                                          Text('This method is based on the belief that:', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('“The way we think influences how we feel and how we behave.”', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
                                          SizedBox(height: 8),
                                          Text('For example, if a person constantly thinks negatively (“I will never succeed”), they start feeling hopeless and may stop trying altogether.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('What is the CBT Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The CBT Test is a self-assessment tool that tracks a person\'s thought patterns, emotional responses, and behaviors.\nThis test helps identify symptoms such as stress, anxiety, depression, low self-esteem, lack of confidence, and negative thinking patterns.', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Objectives of the CBT Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('To identify negative thoughts\n\nTo trace the thoughts behind distressing emotions and harmful behaviors\n\nTo make the individual aware of their mental health condition\n\nTo prepare the individual for CBT therapy', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('What happens after the CBT Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('If the test results show a high level of negative thinking, CBT therapy sessions may be beneficial.\nIn CBT therapy, a trained counselor or therapist helps the person to:\n\nIdentify negative thoughts\n\nReplace them with positive alternatives\n\nBring about positive behavioral changes', style: TextStyle(color: Colors.black)),
                                          SizedBox(height: 12),
                                          Text('Why should you take the CBT Test?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                                          SizedBox(height: 4),
                                          Text('The CBT test is useful for the following reasons:\n\n✅ Initial evaluation of mental health\n✅ Identifying cognitive distortions\n✅ Developing emotional self-awareness\n✅ Understanding whether therapy is needed\n✅ Providing data to support counseling or therapy sessions', style: TextStyle(color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Close', style: TextStyle(color: iconColor)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                          } else if (test['title'] == 'IQ Test') {
                            _showIQTestInfoDialog(context);
                          } else {
                              showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Depression Scale (PHQ-9) Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What is the Depression Scale?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              SizedBox(height: 4),
              Text('The Depression Scale is a psychological test used to assess mental health. It helps determine whether a person is suffering from depression and to what extent.', style: TextStyle(color: Colors.black)),
              SizedBox(height: 12),
              Text('Purpose of the Depression Scale:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              SizedBox(height: 8),
              Text('৹ To identify whether a person has symptoms of depression \n৹ To determine the severity of depression  mild, moderate, or severe\n৹ To measure changes before and after treatment\n৹ To guide mental health counselors and psychiatrists in their evaluations', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('When should the Depression Scale be used?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('৹ When a person constantly feels sad or low\n৹ If there are changes in sleep, appetite, or mood \n৹ When there a lack of interest in studies work \n৹ If there are thoughts of self-harm or suicide', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Who can use it?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('৹ Psychiatrists\n৹ Counselors\n৹ Doctors\n৹ Trained mental health professionals', style: TextStyle(color: Colors.black)),
              SizedBox(height: 8),
              Text('Important Note:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text('This scale is a supportive tool, not a definitive diagnostic test. If a person scores high, they should consult a professional mental health expert.', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close', style: TextStyle(color: iconColor)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
                          }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              minimumSize: Size(88, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text("Info", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
