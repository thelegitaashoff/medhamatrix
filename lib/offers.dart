import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'test.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
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

  final List<Map<String, String>> offers = [
    {
      'title': 'Summer Discount',
      'description': 'Get 20% off on all summer items.',
      'code': 'SUMMER20'
    },
    {
      'title': 'Buy 1 Get 1 Free',
      'description': 'Applicable on select products.',
      'code': 'BOGO'
    },
    {
      'title': 'Free Delivery',
      'description': 'Enjoy free delivery on orders over \$50.',
      'code': 'FREEDEL'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 248, 255), // Page background
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // Remove AppBar shadow for modern look
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double deviceWidth = MediaQuery.of(context).size.width;
          bool isTablet = width > 600;

          EdgeInsets cardMargin = isTablet
              ? EdgeInsets.symmetric(horizontal: deviceWidth * 0.15, vertical: 16)
              : EdgeInsets.symmetric(horizontal: 12, vertical: 10);

          double fontSizeTitle = isTablet ? 22 : 17;
          double fontSizeDesc = isTablet ? 16 : 13;
          double couponFontSize = isTablet ? 17 : 14;

          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Container(
                  margin: cardMargin,
                  decoration: BoxDecoration(
                    color: Colors.white, // Box background
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer['title'] ?? '',
                                style: TextStyle(
                                  fontSize: fontSizeTitle,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                offer['description'] ?? '',
                                style: TextStyle(
                                  fontSize: fontSizeDesc,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            offer['code'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: couponFontSize,
                              letterSpacing: 1.0,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
