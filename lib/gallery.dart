import 'package:flutter/material.dart';
import 'profile.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
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

  final List<String> imageUrls = const [
    // Replace these URLs with your gallery images (network or from assets)
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?w=600&q=80',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=600&q=80',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=600&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=600&q=80',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?w=600&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final crossAxisCount = isWide ? 3 : 2;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gallery'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(221, 0, 0, 0),
            elevation: 1,
          ),
          backgroundColor: Color.fromARGB(255, 224, 248, 255),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: GridView.builder(
              itemCount: imageUrls.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(4, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blueGrey.shade600,
                      width: 1.2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 56, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
