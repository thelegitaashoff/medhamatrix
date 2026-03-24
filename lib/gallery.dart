import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  static const List<String> imageUrls = [
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?w=600&q=80',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=600&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=600&q=80',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?w=600&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Gallery', subtitle: 'Highlights and recent activity'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Gallery Stream',
            subtitle: 'Browse visual highlights from sessions, programs, and student activities.',
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 900
                  ? 3
                  : width > 560
                      ? 2
                      : 1;
              final aspectRatio = width > 900 ? 1.1 : 1.05;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: imageUrls.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) {
                  return MedhaCard(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: MedhaColors.surfaceAlt,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined, size: 48, color: MedhaColors.muted),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
