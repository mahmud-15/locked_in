import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  String selectedRelation = 'Family';

  final List<Map<String, dynamic>> relations = [
    {'name': 'Family', 'icon': '🤝'},
    {'name': 'Friend', 'icon': '👬'},
    {'name': 'Partner', 'icon': '🤝'},
    {'name': 'Colleague', 'icon': '👥'},
    {'name': 'Others', 'icon': '👤'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 80.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Trusted Account',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Choose your accountability partner',
              style: TextStyle(
                color: AppColors.textSecondary,
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
            const CommonTextField(
              label: 'Full Name',
              hintText: 'Enter full name',
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: 20.h),
            const CommonTextField(
              label: 'Email',
              hintText: 'Enter email address',
              prefixIcon: Icons.mail_outline,
            ),
            SizedBox(height: 20.h),
            const CommonTextField(
              label: 'Contact Number',
              hintText: 'Enter contact no',
              prefixIcon: Icons.phone_outlined,
            ),
            SizedBox(height: 28.h),
            Text(
              'Relation',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: relations.map((rel) {
                final isSelected = selectedRelation == rel['name'];
                return GestureDetector(
                  onTap: () => setState(() => selectedRelation = rel['name']),
                  child: Container(
                    width: (1.sw - 60.w) / 2,
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFF1F5F9),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(rel['icon'], style: TextStyle(fontSize: 20.sp)),
                        SizedBox(width: 12.w),
                        Text(
                          rel['name'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 48.h),
            _BottomButton(onPressed: () => Navigator.pop(context)),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BottomButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Confirm',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
