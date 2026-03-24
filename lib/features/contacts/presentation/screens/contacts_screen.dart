import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/contacts/presentation/screens/add_contact_screen.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trusted Contacts',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage your accountability partners',
                style: TextStyle(fontSize: 14.sp, color: AppColors.gray),
              ),
              SizedBox(height: 24.h),
              _AddContactButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddContactScreen()),
                  );
                },
              ),
              SizedBox(height: 32.h),
              const _ContactListItem(
                name: 'Jane Doe',
                relation: 'Family',
                email: 'www.jhon.com',
                phone: '+234 7846 3847',
              ),
              const _ContactListItem(
                name: 'Jane Doe',
                relation: 'Family',
                email: 'www.jhon.com',
                phone: '+234 7846 3847',
              ),
              const _ContactListItem(
                name: 'Jane Doe',
                relation: 'Family',
                email: 'www.jhon.com',
                phone: '+234 7846 3847',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddContactButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddContactButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'Add Trusted contact',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactListItem extends StatelessWidget {
  final String name;
  final String relation;
  final String email;
  final String phone;

  const _ContactListItem({
    required this.name,
    required this.relation,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: Color(0xFF8B5CF6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.split(' ').map((e) => e[0]).join(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  relation,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
                ),
                SizedBox(height: 12.h),
                _InfoRow(icon: Icons.email_outlined, text: email),
                SizedBox(height: 8.h),
                _InfoRow(icon: Icons.phone_outlined, text: phone),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.gray),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.gray),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(fontSize: 13.sp, color: AppColors.gray),
        ),
      ],
    );
  }
}
