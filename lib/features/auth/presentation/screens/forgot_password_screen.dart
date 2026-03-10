import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/auth/presentation/widgets/auth_layout.dart';
import 'package:locked_in/shared/widgets/common_button.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/utils/validators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Forgot Password',
      subtitle: 'Enter your email and get OTP for verification',
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
            SizedBox(height: 48.h),
            CommonButton(
              text: 'Get OTP',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // TODO: Implement forgot password logic
                  context.push(RoutePaths.verifyOtp);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
