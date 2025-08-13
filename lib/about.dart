import 'package:flutter/material.dart';
import 'profile.dart';
import 'payment.dart';

class AboutUsMedhaMatrixPage extends StatefulWidget {
  const AboutUsMedhaMatrixPage({super.key});

  @override
  State<AboutUsMedhaMatrixPage> createState() => _AboutUsMedhaMatrixPageState();
}

class _AboutUsMedhaMatrixPageState extends State<AboutUsMedhaMatrixPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> aboutItems = [
    {
      'title': 'Our Mission',
      'content': 'To empower students, parents, and teachers intellectually and emotionally, building a positive, understanding, and inspiring educational environment for all.',
      'icon': Icons.visibility_rounded,
    },
    {
      'title': 'Introduction to MedhaMatrix',
      'content': 'Medhamatrix, built by Vidyasagar Multipurpose Foundation, is dedicated to empowering students, parents, and teachers through mental, educational, social, and personal development. Our team fosters positive life transformations via counseling, guidance, and targeted support—helping individuals return to the right path and thrive. We serve both urban and rural communities and bridge access to government schemes for the underprivileged.',
      'icon': Icons.lightbulb_rounded,
    },
    {
      'title': 'Why us?',
      'content': 'In today\'s fast-paced, high-pressure world, students face mounting expectations without always receiving personal evaluation of their own strengths. This can result in stress, anxiety, or loss of direction. MedhaMatrix addresses these unmet needs with intellectual assessments and tailored guidance, preventing negative outcomes through proactive understanding and support.',
      'icon': Icons.psychology_rounded,
    },
    {
      'title': 'Programs & Benefits',
      'content': 'Personalized, scientific IQ assessments and detailed reports.\nOfficial IQ certificates for academic/personal portfolios.\nFree first counseling session (joint for student and parent).\nExpert counseling for exam stress, confidence, mindset, and open family communication.\nAnnual training for teachers on IQ, EQ, behavioral analysis, and classroom strategies.\nSpecial parent initiatives: counseling, expert talks, Q&A, and conclave events.',
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'title': 'Who We Help',
      'content': 'Students: Identify intelligence, personality, and guide toward the best education/career fit.\nParents: Practical advice for building self-confidence, handling academic difficulties, exam stress, and supporting growth.\nTeachers: Empowerment to understand and support each child’s unique potential.',
      'icon': Icons.groups_rounded,
    },
    {
      'title': 'Contact',
      'content': 'Email: support@medhamatrix.com\nWebsite: www.medhamatrix.com',
      'icon': Icons.email_rounded,
    },
  ];

  final Color iconColor = const Color.fromARGB(250, 57, 201, 245);

  List<bool> _expanded = [];

  @override
  void initState() {
    super.initState();
    _expanded = List<bool>.filled(aboutItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            children: aboutItems.asMap().entries.map((entry) {
              int idx = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isExpanded = _expanded[idx];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded[idx] = !isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200, width: 0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 224, 248, 255),
                            child: Icon(item['icon'], color: iconColor, size: 28),
                            radius: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: Container(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            item['content'],
                            style: const TextStyle(fontSize: 15.5, color: Colors.black87),
                          ),
                        ),
                        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
