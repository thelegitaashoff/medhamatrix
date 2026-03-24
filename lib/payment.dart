import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';
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
    final paymentOptions = [
      PaymentOption(
        icon: Icons.credit_card_outlined,
        title: 'Credit / Debit Card',
        subtitle: 'Pay securely using your card',
      ),
      PaymentOption(
        icon: Icons.qr_code_scanner_rounded,
        title: 'UPI / QR',
        subtitle: 'Google Pay, PhonePe, Paytm, and more',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UpiPaymentOptionsPage(
                amount: 100.0,
                userId: 'user123',
                callbackUrl: 'https://yourapp.com/payment/callback',
              ),
            ),
          );
        },
      ),
      PaymentOption(
        icon: Icons.account_balance_wallet_outlined,
        title: 'PhonePe',
        subtitle: 'Pay securely with PhonePe gateway',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhonePePaymentPage(
                amount: 100.0,
                userId: 'user123',
                callbackUrl: 'https://yourapp.com/payment/callback',
              ),
            ),
          );
        },
      ),
    ];

    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Payment', subtitle: 'Choose your payment method'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Payment Options',
            subtitle: 'Complete your booking or assessment purchase with a secure method.',
          ),
          const SizedBox(height: 18),
          ...List.generate(
            paymentOptions.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildPaymentOptionBox(paymentOptions[index], index),
            ),
          ),
          const SizedBox(height: 10),
          MedhaPrimaryButton(
            label: 'Proceed to Pay',
            icon: Icons.arrow_forward_rounded,
            onPressed: selectedIndex == null
                ? null
                : () {
                    final selectedOption = paymentOptions[selectedIndex!];
                    if (selectedOption.onTap != null) {
                      selectedOption.onTap!();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${selectedOption.title} integration coming soon!')),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionBox(PaymentOption option, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => setState(() => selectedIndex = index),
      child: MedhaCard(
        child: Row(
          children: [
            MedhaIconTile(
              icon: option.icon,
              size: 58,
              backgroundColor: isSelected ? MedhaColors.hero : const Color(0xFFEAF6F4),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                  const SizedBox(height: 4),
                  Text(option.subtitle, style: const TextStyle(fontSize: 14, color: MedhaColors.muted)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? MedhaColors.primary : MedhaColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
