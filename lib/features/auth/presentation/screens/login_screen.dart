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
import 'package:locked_in/core/utils/snackbar_utils.dart';
import 'package:locked_in/features/auth/presentation/providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPassword = ref.watch(loginPasswordVisibleProvider);
    final loginState = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.showError(context, next.errorMessage!);
      }
    });

    return AuthLayout(
      title: 'Sign in',
      subtitle: 'Hi! Welcome back',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),
            CommonTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter password',
              prefixIcon: Icons.lock_outline,
              obscureText: !showPassword,
              validator: Validators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    ref.read(loginPasswordVisibleProvider.notifier).state =
                        !showPassword,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push(RoutePaths.forgotPassword),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            CommonButton(
              text: 'Sign In',
              isLoading: loginState.isLoading,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  ref
                      .read(loginProvider.notifier)
                      .login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                }
              },
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => context.push(RoutePaths.register),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
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
