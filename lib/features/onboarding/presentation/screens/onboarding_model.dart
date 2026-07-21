import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_images.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String? image;
  final IconData? icon;
  final Color? iconColor;

  OnboardingModel({
    required this.title,
    required this.description,
    this.image,
    this.icon,
    this.iconColor,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: 'Lock Mobile Apps',
    description:
        'Temporarily lock distracting apps to stay focused on what matters',
    image: AppImages.lock,
  ),
  OnboardingModel(
    title: 'Accountability Partner',
    description:
        'Add a trusted contact who can help you unlock apps in emergencies',
    icon: Icons.group_rounded,
    iconColor: const Color(0xFF3B82F6), // Vibrant blue to match the previous shield's colour scheme
  ),
  OnboardingModel(
    title: 'Emergency Access',
    description:
        'Request unlock codes from your trusted contact when you truly need it',
    image: AppImages.emergency,
  ),
];
