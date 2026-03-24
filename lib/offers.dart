import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class OffersPage extends StatelessWidget {
  OffersPage({super.key});

  final List<Map<String, String>> offers = const [
    {
      'title': 'Summer Discount',
      'description': 'Get 20% off on selected wellness and learning plans.',
      'code': 'SUMMER20',
    },
    {
      'title': 'Buy 1 Get 1',
      'description': 'Applicable on selected programs and bundled sessions.',
      'code': 'BOGO',
    },
    {
      'title': 'Free Delivery',
      'description': 'Enjoy free delivery on orders over \$50.',
      'code': 'FREEDEL',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Offers', subtitle: 'Current plans and discounts'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Offer Center',
            subtitle: 'Save on assessments, sessions, and special MedhaMatrix packages.',
          ),
          const SizedBox(height: 18),
          ...offers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: MedhaCard(
                child: Row(
                  children: [
                    const MedhaIconTile(icon: Icons.local_offer_outlined, size: 62),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                          const SizedBox(height: 6),
                          Text(offer['description']!, style: const TextStyle(fontSize: 14, height: 1.4, color: MedhaColors.muted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF7E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        offer['code']!,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: MedhaColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
