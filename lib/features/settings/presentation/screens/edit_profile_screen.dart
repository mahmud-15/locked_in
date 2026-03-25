import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
              'Edit Profile',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Update your details',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              label: 'Name',
              hintText: 'Jhon Luna',
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: 24.h),
            CommonTextField(
              label: 'Email',
              hintText: 'jhonluna@gmail.com',
              prefixIcon: Icons.email_outlined,
            ),
            const Spacer(),
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
