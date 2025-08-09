import 'package:flutter/material.dart';

class AboutUsMedhaMatrixPage extends StatefulWidget {
  const AboutUsMedhaMatrixPage({super.key});

  @override
  State<AboutUsMedhaMatrixPage> createState() => _AboutUsMedhaMatrixPageState();
}

class _AboutUsMedhaMatrixPageState extends State<AboutUsMedhaMatrixPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed
  }

  Widget boxedSection({
    required String title,
    required Widget body,
    IconData? icon,
    Color? iconBg,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 14,
            spreadRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: iconBg ?? Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 7),
                body,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bulletList(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 17)),
                      Expanded(child: Text(e, style: const TextStyle(fontSize: 15.5))),
                    ],
                  ),
                ))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission block at the very top
              boxedSection(
                title: "Our Mission",
                icon: Icons.visibility_rounded,
                iconBg: Colors.orange,
                body: const Text(
                  "To empower students, parents, and teachers intellectually and emotionally, building a positive, understanding, and inspiring educational environment for all.",
                  style: TextStyle(fontSize: 15.5, fontStyle: FontStyle.italic, color: Colors.deepOrange),
                ),
              ),
              // Organization Introduction
              boxedSection(
                title: "Introduction to MedhaMatrics",
                icon: Icons.lightbulb_rounded,
                iconBg: Colors.deepPurple,
                body: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 15.5, color: Colors.black),
                      children: [
                        const TextSpan(text: "Medhamatrics, built by "),
                        TextSpan(
                          text: "Vidyasagar Multipurpose Foundation",
                          style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ", is dedicated to empowering students, parents, and teachers through mental, educational, social, and personal development. Our team fosters positive life transformations via counseling, guidance, and targeted support—helping individuals return to the right path and thrive. We serve both urban and rural communities and bridge access to government schemes for the underprivileged."),
                      ],
                    ),
                  ),
                ),
              ),
              // Why MedhaMatrix
              boxedSection(
                title: "Why us?",
                icon: Icons.psychology_rounded,
                iconBg: Colors.indigo,
                body: const Text(
                  "In today's fast-paced, high-pressure world, students face mounting expectations without always receiving personal evaluation of their own strengths. This can result in stress, anxiety, or loss of direction. MedhaMatrix addresses these unmet needs with intellectual assessments and tailored guidance, preventing negative outcomes through proactive understanding and support.",
                  style: TextStyle(fontSize: 15.5),
                ),
              ),
              // MedhaMatrix Benefits & Programs
              boxedSection(
                  title: "Programs & Benefits",
                  icon: Icons.workspace_premium_rounded,
                  iconBg: Colors.teal,
                  body: bulletList([
                    "Personalized, scientific IQ assessments and detailed reports.",
                    "Official IQ certificates for academic/personal portfolios.",
                    "Free first counseling session (joint for student and parent).",
                    "Expert counseling for exam stress, confidence, mindset, and open family communication.",
                    "Annual training for teachers on IQ, EQ, behavioral analysis, and classroom strategies.",
                    "Special parent initiatives: counseling, expert talks, Q&A, and conclave events.",
                  ])),
              // Who We Help
              boxedSection(
                  title: "Who We Help",
                  icon: Icons.groups_rounded,
                  iconBg: Colors.green,
                  body: bulletList([
                    "Students: Identify intelligence, personality, and guide toward the best education/career fit.",
                    "Parents: Practical advice for building self-confidence, handling academic difficulties, exam stress, and supporting growth.",
                    "Teachers: Empowerment to understand and support each child’s unique potential.",
                  ])),
              // Contact
              boxedSection(
                  title: "Contact",
                  icon: Icons.email_rounded,
                  iconBg: Colors.blue,
                  body: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Email: support@medhamatrics.com\nWebsite: www.medhamatrics.com",
                      style: TextStyle(fontSize: 15.5, color: Colors.indigo),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
