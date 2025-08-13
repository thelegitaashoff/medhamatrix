    
import 'package:flutter/material.dart';

class BookingSectionPage extends StatefulWidget {
  final String? initialCounselor;

  const BookingSectionPage({Key? key, this.initialCounselor}) : super(key: key);

  @override
  State<BookingSectionPage> createState() => _BookingSectionPageState();
}

class _BookingSectionPageState extends State<BookingSectionPage> {
  String? selectedCounselor;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final Color accentColor = const Color.fromARGB(250, 57, 201, 245);

  final List<String> counselors = [
    'Student Counseling',
    'Career Counseling',
    'Parent Counseling',
  ];

  final List<String> timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    selectedCounselor = widget.initialCounselor; // Pre-select counselor if passed
  }

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
        final double fontSizeSubtitle = w(16);
        final double buttonFontSize = w(18);
        final double buttonPaddingHorizontal = w(32);
        final double buttonPaddingVertical = h(12);
        final double gridHeight = h(300);

        return Scaffold(
          appBar: AppBar(
            title: Text('Book Session', style: TextStyle(color: Colors.black, fontSize: fontSizeTitle)),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 224, 248, 255),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 1000 : double.infinity),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(containerPadding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 5),
                      )
                    ],
                    border: Border.all(color: Colors.grey[200]!, width: 0.7),
                  ),
                  padding: EdgeInsets.all(containerPadding),
                  margin: EdgeInsets.only(bottom: containerMargin),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Your Counseling Session',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSizeTitle,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: verticalPadding),
                        Text(
                          'Select Counseling Type',
                          style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
                        ),
                        SizedBox(height: verticalPadding / 2),
                        DropdownButtonFormField<String>(
                          value: selectedCounselor,
                          items: counselors
                              .map((counselor) => DropdownMenuItem(
                                    value: counselor,
                                    child: Text(counselor, style: TextStyle(color: Colors.black, fontSize: buttonFontSize)),
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor, width: 1.2),
                            ),
                          ),
                          onChanged: (value) => setState(() => selectedCounselor = value),
                          dropdownColor: Colors.white,
                        ),
                        SizedBox(height: verticalPadding),
                        Text(
                          'Choose Date',
                          style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
                        ),
                        SizedBox(height: verticalPadding / 2),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: accentColor),
                                ),
                                child: Text(
                                  selectedDate == null
                                      ? 'Pick Date'
                                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                  style: TextStyle(color: Colors.black, fontSize: buttonFontSize),
                                ),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 180)),
                                  );
                                  if (picked != null) setState(() {
                                    selectedDate = picked;
                                    selectedTimeSlot = null; // Reset time slot when date changes
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding),
                        Text(
                          'Select Time Slot',
                          style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
                        ),
                        SizedBox(height: verticalPadding / 2),
                        Container(
                          height: gridHeight,
                          child: selectedDate == null
                              ? Center(
                                  child: Text(
                                    'Please select a date first',
                                    style: TextStyle(color: Colors.grey, fontSize: buttonFontSize),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: w(200),
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: timeSlots.length,
                                  itemBuilder: (context, index) {
                                    final time = timeSlots[index];
                                    final isSelected = time == selectedTimeSlot;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTimeSlot = time;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: w(16),
                                          vertical: h(12),
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected ? accentColor : Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected ? accentColor : Colors.grey,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              time,
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: w(24),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        SizedBox(height: verticalPadding * 1.5),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: buttonPaddingHorizontal,
                                vertical: buttonPaddingVertical,
                              ),
                              child: Text('Confirm Booking', style: TextStyle(color: Colors.white, fontSize: w(20))),
                            ),
                            onPressed: (selectedCounselor != null &&
                                    selectedDate != null &&
                                    selectedTimeSlot != null)
                                ? () {
                                    // Add your booking logic here (API call, database save, etc.)
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text('Booking Confirmed', style: TextStyle(color: Colors.black)),
                                        content: Text(
                                          'Your ${selectedCounselor!} session is booked for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedTimeSlot.',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('OK', style: TextStyle(color: accentColor)),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        )
                      ],
                    ),
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
