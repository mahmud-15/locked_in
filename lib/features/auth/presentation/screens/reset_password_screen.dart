import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/features/auth/presentation/widgets/auth_layout.dart';
import 'package:locked_in/shared/widgets/common_button.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_ui_provider.dart';

import 'package:locked_in/core/utils/validators.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showNewPassword = ref.watch(resetNewPasswordVisibleProvider);
    final showConfirmPassword = ref.watch(resetConfirmPasswordVisibleProvider);

    return AuthLayout(
      title: 'Reset Password',
      subtitle: 'Hi! Welcome back',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextField(
              controller: _passwordController,
              label: 'New Password',
              hintText: 'Enter password',
              prefixIcon: Icons.lock_outline,
              obscureText: !showNewPassword,
              validator: Validators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showNewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    ref.read(resetNewPasswordVisibleProvider.notifier).state =
                        !showNewPassword,
              ),
            ),
            SizedBox(height: 24.h),
            CommonTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hintText: 'Enter password',
              prefixIcon: Icons.lock_outline,
              obscureText: !showConfirmPassword,
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    ref
                            .read(resetConfirmPasswordVisibleProvider.notifier)
                            .state =
                        !showConfirmPassword,
              ),
            ),
            SizedBox(height: 48.h),
            CommonButton(
              text: 'Continue',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // TODO: Implement reset logic
                  context.go(RoutePaths.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
