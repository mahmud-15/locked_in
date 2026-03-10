import 'package:flutter/material.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in/core/constants/app_images.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

const _outPrecise = Cubic(0.19, 1.0, 0.22, 1.0);

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Logo animations
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  // Text animations
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _textSpacing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // logo: 0.0 to 0.5
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // text: 0.3 to 0.8
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: _outPrecise),
      ),
    );
    _textSpacing = Tween<double>(begin: 4.0, end: -0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutQuart),
      ),
    );

    _controller.forward();

    // Trigger auth check after animation to ensure splash is visible for 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        ref.read(authProvider.notifier).checkAuth();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text Column with Rising/Fade effect
                Opacity(
                  opacity: _textFade.value,
                  child: Transform.translate(
                    offset: Offset(0, _textSlide.value),
                    child: Text(
                      'Locked In',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        letterSpacing: _textSpacing.value,
                        color: AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Logo with Pop/Fade effect
                Opacity(
                  opacity: _logoFade.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Image.asset(AppImages.lock, width: 48, height: 48),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
