import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF373737)),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 70.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Update your password',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              label: 'Current Password',
              hintText: '**************',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureCurrent,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.gray,
                ),
                onPressed: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
              ),
            ),
            SizedBox(height: 24.h),
            CommonTextField(
              label: 'New Password',
              hintText: '**************',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureNew,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.gray,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            SizedBox(height: 24.h),
            CommonTextField(
              label: 'Confirm Password',
              hintText: '**************',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.gray,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
