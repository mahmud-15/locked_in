import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/features/auth/presentation/widgets/auth_layout.dart';
import 'package:locked_in/shared/widgets/common_button.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_ui_provider.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:locked_in/core/utils/validators.dart';

class UserVerifyScreen extends ConsumerStatefulWidget {
  const UserVerifyScreen({super.key});

  @override
  ConsumerState<UserVerifyScreen> createState() => _UserVerifyScreenState();
}

class _UserVerifyScreenState extends ConsumerState<UserVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // Formatter to match 00.42 style
  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins.$secs';
  }

  @override
  Widget build(BuildContext context) {
    final timerSeconds = ref.watch(otpTimerProvider);

    return AuthLayout(
      title: 'Verify OTP',
      subtitle: 'Enter the code sent to your email',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.scale,
                cursorColor: AppColors.primary,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12.r),
                  fieldHeight: 70.h,
                  fieldWidth: 80.w,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey.shade100,
                  selectedColor: AppColors.primary,
                  borderWidth: 1,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                validator: Validators.validateOTP,
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 32.h),
            const CommonText(
              'A code has been sent to your email',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.white800,
            ),
            SizedBox(height: 12.h),
            CommonText(
              _formatTimer(timerSeconds),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            SizedBox(height: 48.h),
            CommonButton(
              text: 'Get OTP',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // After registration verification, go to home or success
                  context.go(RoutePaths.home);
                }
              },
            ),
            SizedBox(height: 24.h),
            Column(
              children: [
                const CommonText(
                  'Dont get OTP?',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white800,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    _otpController.clear();
                    ref.read(otpTimerProvider.notifier).resetTimer();
                  },
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
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
