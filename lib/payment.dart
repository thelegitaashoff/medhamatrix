import 'package:flutter/material.dart';
import 'phonepe_payment_page.dart';
import 'upi_payment_options.dart';
class PaymentOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<PaymentOption> paymentOptions = [
      PaymentOption(
        icon: Icons.credit_card,
        title: "Credit / Debit Card",
        subtitle: "Pay securely using your card",
      ),
      PaymentOption(
        icon: Icons.qr_code_scanner_rounded,
        title: "UPI / QR",
        subtitle: "Google Pay, PhonePe, Paytm, etc.",
        onTap: () {
          // Navigate to UPI options page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpiPaymentOptionsPage(
                amount: 100.0, // This should be dynamic based on your app
                userId: 'user123', // This should be dynamic
                callbackUrl: 'https://yourapp.com/payment/callback',
              ),
            ),
          );
        },
      ),
      PaymentOption(
        icon: Icons.payment,
        title: "PhonePe",
        subtitle: "Pay securely with PhonePe gateway",
        onTap: () {
          // Navigate to PhonePe payment page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhonePePaymentPage(
                amount: 100.0, // This should be dynamic based on your app
                userId: 'user123', // This should be dynamic
                callbackUrl: 'https://yourapp.com/payment/callback',
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Payment Method'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          children: [
            for (int i = 0; i < paymentOptions.length; i++)
              _buildPaymentOptionBox(paymentOptions[i], i),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                label: const Text("Proceed to Pay", style: TextStyle(fontSize: 16)),
                onPressed: selectedIndex != null
                    ? () {
                        final selectedOption = paymentOptions[selectedIndex!];
                        if (selectedOption.onTap != null) {
                          selectedOption.onTap!();
                        } else {
                          // Handle other payment methods
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${selectedOption.title} integration coming soon!"),
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionBox(PaymentOption option, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
        if (option.onTap != null) option.onTap!();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.blueGrey.shade100,
            width: isSelected ? 2.0 : 1.2,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.13),
            child: Icon(option.icon, color: Colors.blue[900]),
          ),
          title: Text(option.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(option.subtitle, style: const TextStyle(fontSize: 13)),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.blue, size: 28)
              : const Icon(Icons.radio_button_off, color: Colors.grey, size: 26),
        ),
      ),
    );
  }
}
