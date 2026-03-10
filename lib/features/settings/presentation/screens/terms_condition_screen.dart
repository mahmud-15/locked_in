import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        'Terms & Condition',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      CommonText(
                        'Data protection info',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    CommonText(
                      'We are building a digital well-being platform designed to help people use technology more mindfully. Our goal is to reduce distractions, improve focus, and create healthier screen habits without making life complicated.\n\nThrough smart app controls, usage insights, and simple tools, we help users stay productive while maintaining balance in their daily digital life.\n\nWe believe technology should support your goals — not control your time.\n\nWe are building a digital well-being platform designed to help people use technology more mindfully. Our goal is to reduce distractions, improve focus, and create healthier screen habits without making life complicated.\n\nThrough smart app controls, usage insights, and simple tools, we help users stay productive while maintaining balance in their daily digital life.\n\nWe believe technology should support your goals — not control your time.',
                      fontSize: 14,
                      height: 1.6,
                      color: const Color(0xFF4B5563),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
