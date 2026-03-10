import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_images.dart';
import 'package:locked_in/shared/widgets/common_text.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showLogo;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: Colors.black)
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showLogo) ...[
                SizedBox(height: 20.h),
                Image.asset(AppImages.lock, height: 60.h, width: 45.w),
                SizedBox(height: 24.h),
              ],
              CommonText(
                title,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              CommonText(
                subtitle,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.white800,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
