import 'package:flutter/material.dart';
import 'booking_section_page.dart'; // Make sure this file exists and is properly set up
import 'profile.dart';
import 'dashboard.dart';
import 'payment.dart';

class CounselingSelectionPage extends StatefulWidget {
  final bool openStudentCounselingDialogOnLoad;
  final bool openParentCounselingDialogOnLoad;

  const CounselingSelectionPage({super.key, this.openStudentCounselingDialogOnLoad = false, this.openParentCounselingDialogOnLoad = false});

  @override
  State<CounselingSelectionPage> createState() => _CounselingSelectionPageState();
}

class _CounselingSelectionPageState extends State<CounselingSelectionPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.openStudentCounselingDialogOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showStudentCounselingDialog();
      });
    }
    if (widget.openParentCounselingDialogOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showParentCounselingDialog();
      });
    }
  }

  void _showStudentCounselingDialog() {
    final counsel = counselors.firstWhere((c) => c['title'] == 'Student Counseling');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Student Counseling Instructions',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          counsel['instructions'],
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: iconColor)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
            ),
            child: Text('Proceed', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context); // Close the instructions dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSectionPage(
                    initialCounselor: counsel['title'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showParentCounselingDialog() {
    final counsel = counselors.firstWhere((c) => c['title'] == 'Parent Guidance');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Parent Counseling Instructions',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          counsel['instructions'],
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: iconColor)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
            ),
            child: Text('Proceed', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context); // Close the instructions dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingSectionPage(
                    initialCounselor: counsel['title'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditableProfilePage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Map<String, dynamic>> counselors = [
    {
      'title': 'Student Counseling',
      'subtitle': 'Support for academic and personal growth',
      'icon': Icons.school,
      'instructions':
          '• Sessions are confidential.\n• Bring any academic or personal concerns.\n• Arrive 5 minutes early.\n• Be honest for best support.',
    },
    {
      'title': 'Career Counseling',
      'subtitle': 'Explore career options and planning',
      'icon': Icons.work_outline,
      'instructions':
          '• Prepare your questions in advance.\n• Discuss strengths and interests.\n• Career resources will be provided.\n• Sessions last 30 minutes.',
    },
    {
      'title': 'Parent Counseling',
      'subtitle': 'Support for parenting challenges and advice',
      'icon': Icons.family_restroom,
      'instructions':
          '• Sessions are private and supportive.\n• Share your concerns openly.\n• Receive practical advice and resources.\n• Sessions last 30 minutes.',
    },
  ];

  final Color iconColor = const Color.fromARGB(250, 57, 201, 245);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counseling", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding = constraints.maxWidth * 0.04;
          double verticalPadding = constraints.maxHeight * 0.02;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(
              children: counselors.map((counsel) {
                return Container(
                  margin: EdgeInsets.only(bottom: verticalPadding * 2),
                  padding: EdgeInsets.all(horizontalPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        backgroundColor: Colors.white,
                        child: Icon(
                          counsel['icon'],
                          color: iconColor,
                          size: 28,
                        ),
                        radius: 28,
                      ),
                      SizedBox(width: horizontalPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              counsel['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              counsel['subtitle'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
                              backgroundColor: Colors.white,
                              title: Text(
                                'Counseling Instructions',
                                style: TextStyle(color: Colors.black),
                              ),
                              content: Text(
                                counsel['instructions'],
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                TextButton(
                                  child:
                                      Text('Cancel', style: TextStyle(color: iconColor)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: iconColor,
                                  ),
                                  child: Text('Proceed',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.pop(context); // Close the instructions dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingSectionPage(
                                          initialCounselor: counsel['title'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Book", style: TextStyle(color: Colors.white)),
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
