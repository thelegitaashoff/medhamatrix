import 'package:flutter/material.dart';

class CounsellingPage extends StatelessWidget {
  const CounsellingPage({super.key});

  Widget _buildCounselingCard(BuildContext context, String title) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 33, 208, 252),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon placeholder for customized icon
          SizedBox(width: screenWidth * 0.05),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counselling'),
        backgroundColor: Color(0xFFFFD9D9),
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCounselingCard(context, 'Student Counseling'),
            _buildCounselingCard(context, 'Parent Counseling'),
            _buildCounselingCard(context, 'Career Sector Counseling'),
          ],
        ),
      ),
    );
  }
}
