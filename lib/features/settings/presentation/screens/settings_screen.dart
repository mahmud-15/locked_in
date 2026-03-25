import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
            _buildSettingTile(
              title: 'Edit Profile',
              onTap: () => context.pushNamed(RouteNames.editProfile),
            ),
            _buildSettingTile(
              title: 'Change Password',
              onTap: () => context.pushNamed(RouteNames.changePassword),
            ),
            _buildSettingTile(
              title: 'Subscription History',
              onTap: () => context.pushNamed(RouteNames.subscriptionHistory),
            ),

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

            SizedBox(height: 16.h),

            // Logout
            _buildSettingTile(
              title: 'Log Out',
              textColor: const Color(0xFFFF564B),
              onTap: () => _showLogoutDialog(context),
            ),

            // Extra space at bottom to ensure scrolling past bottom nav
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // Match exact radius
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CommonText(
                  'Log Out',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF373737),
                ),
                SizedBox(height: 16.h),
                const CommonText(
                  'Are you sure you want to Log out this\nAccount ?',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF676E79),
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const CommonText(
                          'Cancel',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext); // Close dialog
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            context.goNamed(RouteNames.login);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          backgroundColor: const Color(
                            0xFFFF564B,
                          ), // Coral specific to design
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const CommonText(
                          'Confirm',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
    Color? textColor,
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
                fontWeight: textColor != null
                    ? FontWeight.w500
                    : FontWeight.w400,
                color: textColor ?? AppColors.textSecondary,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textColor ?? const Color(0xFF9CA3AF),
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
