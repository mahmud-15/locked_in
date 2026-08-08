import 'package:locked_in/core/constants/app_images.dart';

enum OnboardingPageType {
  boot,
  account,
  screenTime,
  focusDemo,
  accountability,
  summary,
}

class OnboardingModel {
  final String title;
  final String description;
  final String? image;
  final OnboardingPageType pageType;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.pageType,
    this.image,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: 'Step 1: done',
    description:
        'Everyone knows they have a phone addiction, but almost none of them do anything about it.',
    image: AppImages.lock,
    pageType: OnboardingPageType.boot,
  ),
  OnboardingModel(
    title: 'Create your account',
    description:
        'Start with a secure account. No paywall yet — we may add optional 2FA for regulation later.',
    image: AppImages.accountability,
    pageType: OnboardingPageType.account,
  ),
  OnboardingModel(
    title: 'What is your screen time?',
    description:
        'Enter your current daily average so we can show how much time your phone will take over the next 35 years.',
    image: AppImages.lock,
    pageType: OnboardingPageType.screenTime,
  ),
  OnboardingModel(
    title: 'What is a focus session?',
    description:
        'To get your screen time down, use the focus session. Select an app, set a timer, and watch the lock screen appear.',
    image: AppImages.emergency,
    pageType: OnboardingPageType.focusDemo,
  ),
  OnboardingModel(
    title: 'No early escape',
    description:
        'Most focus apps let you end the session whenever. We make it impossible to open the app before your lock finishes unless your Accountability partner lets you back in.',
    image: AppImages.accountability,
    pageType: OnboardingPageType.accountability,
  ),
  OnboardingModel(
    title: 'Unlock your distraction control',
    description:
        'Claim back years of time, use unlimited true lock focus sessions, add an accountability partner for extra security, and stay ad free.',
    image: AppImages.lock,
    pageType: OnboardingPageType.summary,
  ),
];
