import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  Timer? _fallbackTimer;
  bool _useStaticSplash = false;

  @override
  void initState() {
    super.initState();
    _setupSplash();
  }

  Future<void> _setupSplash() async {
    final shouldUseStaticSplash = kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    if (shouldUseStaticSplash) {
      _startStaticSplash();
      return;
    }

    try {
      final controller = VideoPlayerController.asset('assets/slpash_screen.mp4');
      _controller = controller;
      await controller.initialize();
      await controller.setLooping(false);
      controller.play();
      controller.addListener(_handleVideoProgress);
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      _startStaticSplash();
    }
  }

  void _startStaticSplash() {
    _useStaticSplash = true;
    _fallbackTimer = Timer(const Duration(seconds: 2), _goToLogin);
    if (mounted) {
      setState(() {});
    }
  }

  void _handleVideoProgress() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final finished = controller.value.position >= controller.value.duration;
    if (finished) {
      _goToLogin();
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller?.removeListener(_handleVideoProgress);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (!_useStaticSplash && controller != null && controller.value.isInitialized) {
      return Scaffold(
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MedhaColors.page,
      body: Stack(
        children: [
          const Positioned(
            top: -120,
            left: -90,
            child: _SplashBlob(size: 280, color: Color(0xFFDDF3EF)),
          ),
          const Positioned(
            bottom: -120,
            right: -100,
            child: _SplashBlob(size: 300, color: Color(0xFFE6F6F3)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: MedhaColors.primary.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Image.asset('assets/app_logo.png'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MedhaMatrix',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: MedhaColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Student success hub',
                  style: TextStyle(
                    fontSize: 16,
                    color: MedhaColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: MedhaColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _SplashBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2.2),
      ),
    );
  }
}
