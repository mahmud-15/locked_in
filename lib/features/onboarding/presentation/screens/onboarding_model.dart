import 'package:locked_in/core/constants/app_images.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: 'Smart App Locks',
    description:
        'Temporarily lock distracting apps to stay focused on what matters',
    image: AppImages.lock,
  ),
  OnboardingModel(
    title: 'Accountability Partner',
    description:
        'Add a trusted contact who can help you unlock apps in emergencies',
    image: AppImages.accountability,
  ),
  OnboardingModel(
    title: 'Emergency Access',
    description:
        'Request unlock codes from your trusted contact when you truly need it',
    image: AppImages.emergency,
  ),
];
