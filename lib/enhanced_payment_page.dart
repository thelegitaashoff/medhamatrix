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

class EnhancedPaymentPage extends StatefulWidget {
  final double amount;
  final String userId;
  final String callbackUrl;
  final String? mobileNumber;
  final String? email;
  final String? orderInfo;

  const EnhancedPaymentPage({
    super.key,
    required this.amount,
    required this.userId,
    required this.callbackUrl,
    this.mobileNumber,
    this.email,
    this.orderInfo,
  });

  @override
  State<EnhancedPaymentPage> createState() => _EnhancedPaymentPageState();
}

class _EnhancedPaymentPageState extends State<EnhancedPaymentPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<PaymentOption> paymentOptions = [
      PaymentOption(
        icon: Icons.credit_card,
        title: "Credit / Debit Card",
        subtitle: "Pay securely using your card",
        onTap: () {
          _showComingSoon("Credit / Debit Card");
        },
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
      PaymentOption(
        icon: Icons.payment,
        title: "PhonePe Direct",
        subtitle: "Pay directly with PhonePe gateway",
        onTap: () {
          // Navigate to PhonePe payment page
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
      PaymentOption(
        icon: Icons.account_balance,
        title: "Net Banking",
        subtitle: "Pay using your bank account",
        onTap: () {
          _showComingSoon("Net Banking");
        },
      ),
      PaymentOption(
        icon: Icons.account_balance_wallet,
        title: "Wallet",
        subtitle: "Pay using digital wallets",
        onTap: () {
          _showComingSoon("Digital Wallet");
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
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      body: Column(
        children: [
          // Order Summary Card
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.orderInfo != null) ...[
                  Text(
                    widget.orderInfo!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'User ID:',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      widget.userId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Options
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: paymentOptions.length,
              itemBuilder: (context, index) {
                return _buildPaymentOptionBox(paymentOptions[index], index);
              },
            ),
          ),

          // Proceed Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                label: const Text("Proceed to Pay", style: TextStyle(fontSize: 16)),
                onPressed: selectedIndex != null
                    ? () {
                        final selectedOption = paymentOptions[selectedIndex!];
                        selectedOption.onTap?.call();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionBox(PaymentOption option, int index) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          child: Icon(option.icon, color: Colors.blue[900]),
        ),
        title: Text(
          option.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          option.subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.radio_button_off,
          color: isSelected ? Colors.blue : Colors.grey,
          size: 24,
        ),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  void _showComingSoon(String paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.construction, color: Colors.orange),
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
              'Currently, we support UPI payments through PhonePe. Other payment methods will be available in future updates.',
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
              // Navigate to UPI options
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpiPaymentOptionsPage(
                    amount: widget.amount,
                    userId: widget.userId,
                    callbackUrl: widget.callbackUrl,
                    mobileNumber: widget.mobileNumber,
                    email: widget.email,
                  ),
                ),
              );
            },
            child: const Text('Use UPI'),
          ),
        ],
      ),
    );
  }
}
