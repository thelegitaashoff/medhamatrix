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
  TimeOfDay? selectedTime;

  final Color accentColor = const Color.fromARGB(250, 57, 201, 245);

  final List<String> counselors = [
    'Academic Counseling',
    'Career Counseling',
    'Personal Counseling',
    // Add more as needed
  ];

  @override
  void initState() {
    super.initState();
    selectedCounselor = widget.initialCounselor; // Pre-select counselor if passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Session', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book Your Counseling Session',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 22),
              Text(
                'Select Counseling Type',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCounselor,
                items: counselors
                    .map((counselor) => DropdownMenuItem(
                          value: counselor,
                          child: Text(counselor, style: TextStyle(color: Colors.black)),
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
              SizedBox(height: 18),
              Text(
                'Choose Date',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 8),
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
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 180)),
                        );
                        if (picked != null) setState(() => selectedDate = picked);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Text(
                'Choose Time',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: accentColor),
                      ),
                      child: Text(
                        selectedTime == null
                            ? 'Pick Time'
                            : selectedTime!.format(context),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 10, minute: 0),
                        );
                        if (picked != null) setState(() => selectedTime = picked);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                    child: Text('Confirm Booking', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  onPressed: (selectedCounselor != null &&
                          selectedDate != null &&
                          selectedTime != null)
                      ? () {
                          // Add your booking logic here (API call, database save, etc.)
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('Booking Confirmed', style: TextStyle(color: Colors.black)),
                              content: Text(
                                'Your ${selectedCounselor!} session is booked for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedTime!.format(context)}.',
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
    );
  }
}
