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
    final screenHeight = MediaQuery.of(context).size.height;

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) =>
                    _OnboardingContent(model: onboardingPages[index]),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
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
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    text: _currentPage == onboardingPages.length - 1
                        ? 'Get Started'
                        : 'Continue \u2192',
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: _currentPage == index ? 20 : 6,
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
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.08),
            if (model.image != null)
              Image.asset(
                model.image!,
                height: screenHeight * 0.22,
                fit: BoxFit.contain,
              )
            else if (model.icon != null)
              SizedBox(
                height: screenHeight * 0.22,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      color: (model.iconColor ?? AppColors.primary).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      model.icon,
                      size: screenHeight * 0.12,
                      color: model.iconColor ?? AppColors.primary,
                    ),
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.06),
            Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
