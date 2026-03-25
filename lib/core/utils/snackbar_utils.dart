import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = true,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Clear existing snackbars to avoid overlap
    scaffoldMessenger.removeCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CommonText(
                message,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
        elevation: 8,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, isError: true);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, isError: false);
  }
}
