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
import 'package:locked_in/features/auth/presentation/providers/register_provider.dart';

import 'package:locked_in/core/utils/validators.dart';
import 'package:locked_in/core/utils/snackbar_utils.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPassword = ref.watch(registerPasswordVisibleProvider);
    final registerState = ref.watch(registerProvider);

    ref.listen(registerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.showError(context, next.errorMessage!);
      } else if (next.isSuccess) {
        context.push(RoutePaths.userVerify);
      }
    });

    return AuthLayout(
      title: 'Create an Account',
      subtitle: 'Get started with locked in',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextField(
              controller: _nameController,
              label: 'Name',
              hintText: 'Enter your name',
              prefixIcon: Icons.person_outline,
              validator: Validators.validateName,
            ),
            SizedBox(height: 24.h),
            CommonTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24.h),
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
                    ref.read(registerPasswordVisibleProvider.notifier).state =
                        !showPassword,
              ),
            ),
            SizedBox(height: 48.h),
            CommonButton(
              text: 'Continue',
              isLoading: registerState.isLoading,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  ref
                      .read(registerProvider.notifier)
                      .register(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                }
              },
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Text(
                    'Sign In',
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
