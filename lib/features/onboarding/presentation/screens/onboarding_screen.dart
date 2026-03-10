import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'onboarding_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:locked_in/shared/widgets/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < onboardingPages.length - 1)
            TextButton(
              onPressed: () async {
                await ref
                    .read(onboardingProvider.notifier)
                    .completeOnboarding();
                if (mounted) context.go(RoutePaths.login);
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) =>
                  _OnboardingContent(model: onboardingPages[index]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CommonButton(
                    onPressed: () async {
                      if (_currentPage == onboardingPages.length - 1) {
                        await ref
                            .read(onboardingProvider.notifier)
                            .completeOnboarding();
                        if (mounted) context.go(RoutePaths.login);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    text: _currentPage == onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Continue \u2192',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.primary
            : AppColors.indicatorInactive,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final OnboardingModel model;

  const _OnboardingContent({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            model.image,
            height: 157,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            model.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
