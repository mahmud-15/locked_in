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
  double _screenTimeHours = 5;

  String get _screenTimeImpact {
    final totalYears = (_screenTimeHours / 24) * 35;
    final roundedYears = totalYears.toStringAsFixed(1);
    return '$roundedYears years gone to your phone over the next 35 years.';
  }

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
              itemBuilder: (context, index) => _OnboardingContent(
                model: onboardingPages[index],
                screenTimeHours: _screenTimeHours,
                screenTimeImpact: _screenTimeImpact,
                isCurrentPage: _currentPage == index,
                onScreenTimeChanged: (value) {
                  setState(() => _screenTimeHours = value);
                },
              ),
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
                    text: _currentPage == 0
                        ? 'Let’s go'
                        : _currentPage == onboardingPages.length - 1
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
  final double screenTimeHours;
  final String screenTimeImpact;
  final bool isCurrentPage;
  final ValueChanged<double> onScreenTimeChanged;

  const _OnboardingContent({
    required this.model,
    required this.screenTimeHours,
    required this.screenTimeImpact,
    required this.isCurrentPage,
    required this.onScreenTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (model.image != null)
              Image.asset(
                model.image!,
                height: 157,
                width: 120,
                fit: BoxFit.contain,
              ),
            if (model.image != null) const SizedBox(height: 32),
            if (model.pageType == OnboardingPageType.boot)
              Column(
                children: [
                  const Text(
                    'Locked In is booting…',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
              )
            else if (model.pageType == OnboardingPageType.account)
              Column(
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 32),
                  CommonButton(
                    text: 'Create Account',
                    onPressed: () => context.go(RoutePaths.register),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We may add optional 2-factor authentication later for regulation and safety.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            else if (model.pageType == OnboardingPageType.screenTime)
              Column(
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 32),
                  Text(
                    '${screenTimeHours.toStringAsFixed(1)} hours/day',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Slider(
                    value: screenTimeHours,
                    min: 0,
                    max: 18,
                    divisions: 18,
                    activeColor: AppColors.primary,
                    onChanged: onScreenTimeChanged,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    screenTimeImpact,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              )
            else if (model.pageType == OnboardingPageType.focusDemo)
              Column(
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F2EE),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Example focus session',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.smartphone, color: AppColors.primary),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You selected Social, set a 25-minute timer, and the lock screen will appear while the session runs.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.apps,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Social',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '25m',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.lock_outline,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Locked apps stay locked until the timer ends. This is what the app lock screen looks like.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else if (model.pageType == OnboardingPageType.accountability)
              Column(
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
                  const SizedBox(height: 24),
                  const Text(
                    'Unless your Accountability partner lets you back in. This is someone you can set up to unlock apps in emergencies, but it’s up to them to decide if it’s a real emergency.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Most focus apps will just let you end the session whenever. We made it impossible to get into the app before the timer you’ve set to lock in finishes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '• Claim back years lost to your phone',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Unlimited true lock focus sessions',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Accountability partner for extra security',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Ad free experience',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Control your scroll for 7.50 NZD per month billed annually - (90 NZD annually)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'That’s 25 cents per day!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
