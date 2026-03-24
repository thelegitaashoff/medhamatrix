import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

import 'agora_call_page.dart';
import 'models/counseling_session.dart';
import 'services/counseling_session_service.dart';

class BookingSectionPage extends StatefulWidget {
  final String? initialCounselor;

  const BookingSectionPage({super.key, this.initialCounselor});

  @override
  State<BookingSectionPage> createState() => _BookingSectionPageState();
}

class _BookingSectionPageState extends State<BookingSectionPage> {
  String? selectedCounselor;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final List<String> counselors = const [
    'Student Counseling',
    'Career Counseling',
    'Parent Counseling',
  ];

  final List<String> timeSlots = const [
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
    selectedCounselor = widget.initialCounselor;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null;
      });
    }
  }

  String _buildAgoraChannel() {
    final counselorSlug = (selectedCounselor ?? 'session')
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final datePart = selectedDate!.toIso8601String().split('T').first;
    final timePart = selectedTimeSlot!
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return 'medhamatrix-$counselorSlug-$datePart-$timePart';
  }

  Future<void> _confirmBooking() async {
    if (selectedCounselor == null || selectedDate == null || selectedTimeSlot == null) {
      return;
    }

    final channel = _buildAgoraChannel();
    final session = CounselingSession(
      id: channel,
      counselor: selectedCounselor!,
      dateIso: selectedDate!.toIso8601String(),
      timeSlot: selectedTimeSlot!,
      agoraChannel: channel,
      createdAt: DateTime.now(),
    );

    await CounselingSessionService.saveSession(session);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Booking Confirmed'),
        content: Text(
          'Your $selectedCounselor session is booked for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedTimeSlot.\n\nAgora channel: $channel',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: MedhaColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AgoraCallPage(
                    bookedChannelName: channel,
                    readOnlyChannel: true,
                  ),
                ),
              );
            },
            child: const Text('Join Now', style: TextStyle(color: MedhaColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Book Session', subtitle: 'Choose counselor, date, and time'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Booking Desk',
            subtitle: 'Choose a counseling type, pick a date, and reserve your preferred slot.',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Counseling Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MedhaColors.text)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCounselor,
                  items: counselors
                      .map((counselor) => DropdownMenuItem(
                            value: counselor,
                            child: Text(counselor),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedCounselor = value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Choose Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MedhaColors.text)),
                const SizedBox(height: 10),
                MedhaOutlineButton(
                  label: selectedDate == null
                      ? 'Pick Date'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  icon: Icons.calendar_month_rounded,
                  onPressed: _pickDate,
                ),
                const SizedBox(height: 18),
                const Text('Select Time Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MedhaColors.text)),
                const SizedBox(height: 12),
                selectedDate == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text('Please select a date first', style: TextStyle(color: MedhaColors.muted)),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossAxisCount = width > 520 ? 3 : 2;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: timeSlots.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.8,
                            ),
                            itemBuilder: (context, index) {
                              final time = timeSlots[index];
                              final isSelected = time == selectedTimeSlot;
                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => setState(() => selectedTimeSlot = time),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? MedhaColors.primary : MedhaColors.surfaceAlt,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isSelected ? MedhaColors.primary : MedhaColors.border),
                                  ),
                                  child: Center(
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : MedhaColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                const SizedBox(height: 22),
                MedhaPrimaryButton(
                  label: 'Confirm Booking',
                  onPressed: (selectedCounselor != null && selectedDate != null && selectedTimeSlot != null)
                      ? _confirmBooking
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
