import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockStarted = true;
  bool lockEnded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              'Settings',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 4.h),
            const CommonText(
              'Customize your experience',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 32.h),

            // Profile Section
            _buildSectionHeader('Profile'),
            _buildSettingTile(title: 'Edit Profile', onTap: () {}),
            _buildSettingTile(title: 'Change Password', onTap: () {}),
            _buildSettingTile(title: 'Subscription History', onTap: () {}),

            SizedBox(height: 16.h),

            // Notification Section
            _buildSectionHeader('Notification'),
            _buildSwitchTile(
              title: 'Lock Started',
              value: lockStarted,
              onChanged: (val) => setState(() => lockStarted = val),
            ),
            _buildSwitchTile(
              title: 'Lock Ended',
              value: lockEnded,
              onChanged: (val) => setState(() => lockEnded = val),
            ),

            SizedBox(height: 16.h),

            // About App Section
            _buildSectionHeader('About App'),
            _buildSettingTile(
              title: 'About Us',
              onTap: () => context.push(RoutePaths.aboutUs),
            ),
            _buildSettingTile(
              title: 'Terms & Condition',
              onTap: () => context.push(RoutePaths.termsCondition),
            ),
            _buildSettingTile(
              title: 'Privacy Policy',
              onTap: () => context.push(RoutePaths.privacyPolicy),
            ),

            // Extra space at bottom to ensure scrolling past bottom nav
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: CommonText(
        title,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: CommonText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary, // Muted greyish text from image
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF9CA3AF),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              title,
              fontSize: 15,
              color: const Color(0xFF6B7280),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
        ],
      ),
    );
  }
}
