import 'package:flutter/material.dart';
import 'phonepe_payment_page.dart';
import 'example_phonepe_usage.dart';

class UpiOption {
  final String name;
  final String logo;
  final Color color;
  final VoidCallback onTap;

  UpiOption({
    required this.name,
    required this.logo,
    required this.color,
    required this.onTap,
  });
}

class UpiPaymentOptionsPage extends StatefulWidget {
  final double amount;
  final String userId;
  final String callbackUrl;
  final String? mobileNumber;
  final String? email;

  const UpiPaymentOptionsPage({
    super.key,
    required this.amount,
    required this.userId,
    required this.callbackUrl,
    this.mobileNumber,
    this.email,
  });

  @override
  State<UpiPaymentOptionsPage> createState() => _UpiPaymentOptionsPageState();
}

class _UpiPaymentOptionsPageState extends State<UpiPaymentOptionsPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<UpiOption> upiOptions = [
      UpiOption(
        name: 'PhonePe',
        logo: '💜', // You can replace with actual image
        color: const Color(0xFF5A2E98),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhonePePaymentPage(
                amount: widget.amount,
                userId: widget.userId,
                callbackUrl: widget.callbackUrl,
                mobileNumber: widget.mobileNumber,
                email: widget.email,
              ),
            ),
          );
        },
      ),
      UpiOption(
        name: 'Google Pay',
        logo: '🌈',
        color: const Color(0xFF4285F4),
        onTap: () {
          _showComingSoon('Google Pay');
        },
      ),
      UpiOption(
        name: 'Paytm',
        logo: '🔵',
        color: const Color(0xFF00BAF2),
        onTap: () {
          _showComingSoon('Paytm');
        },
      ),
      UpiOption(
        name: 'Amazon Pay',
        logo: '🟠',
        color: const Color(0xFFFF9900),
        onTap: () {
          _showComingSoon('Amazon Pay');
        },
      ),
      UpiOption(
        name: 'BHIM UPI',
        logo: '🇮🇳',
        color: const Color(0xFF003F7F),
        onTap: () {
          _showComingSoon('BHIM UPI');
        },
      ),
      UpiOption(
        name: 'Other UPI Apps',
        logo: '🔗',
        color: Colors.grey,
        onTap: () {
          _showComingSoon('Other UPI Apps');
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose UPI App'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Payment Amount Display
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount to Pay:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // UPI Options List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: upiOptions.length,
                itemBuilder: (context, index) {
                  final option = upiOptions[index];
                  final isSelected = selectedIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? option.color.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? option.color : Colors.grey.shade300,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            option.logo,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      title: Text(
                        option.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? option.color : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        option.name == 'PhonePe' 
                          ? 'Integrated payment gateway'
                          : 'Pay using ${option.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_off,
                        color: isSelected ? option.color : Colors.grey,
                        size: 24,
                      ),
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        
                        // Add a small delay for visual feedback
                        Future.delayed(const Duration(milliseconds: 200), () {
                          option.onTap();
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // PhonePe Demo Button
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExamplePhonePeUsage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.developer_mode),
                      label: const Text('PhonePe Demo & Testing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A2E98),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use this for testing PhonePe integration with custom amounts',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 12),
            Text('$paymentMethod'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$paymentMethod integration is coming soon!'),
            const SizedBox(height: 12),
            const Text(
              'Currently, we have integrated PhonePe payment gateway. Other UPI payment methods will be available in future updates.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to PhonePe payment
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhonePePaymentPage(
                    amount: widget.amount,
                    userId: widget.userId,
                    callbackUrl: widget.callbackUrl,
                    mobileNumber: widget.mobileNumber,
                    email: widget.email,
                  ),
                ),
              );
            },
            child: const Text('Use PhonePe'),
          ),
        ],
      ),
    );
  }
}
