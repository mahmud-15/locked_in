import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/core/utils/snackbar_utils.dart';
import 'package:locked_in/core/utils/validators.dart';
import 'package:locked_in/features/contacts/presentation/providers/add_contact_provider.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

class AddContactScreen extends ConsumerStatefulWidget {
  const AddContactScreen({super.key});

  @override
  ConsumerState<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String selectedRelation = 'Family';

  final List<Map<String, dynamic>> relations = [
    {'name': 'Family', 'icon': '🤝'},
    {'name': 'Friend', 'icon': '👬'},
    {'name': 'Partner', 'icon': '🤝'},
    {'name': 'Colleague', 'icon': '👥'},
    {'name': 'Other', 'icon': '👤'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addContactState = ref.watch(addContactProvider);

    ref.listen(addContactProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.showError(context, next.errorMessage!);
      } else if (next.isSuccess) {
        AppSnackBar.showSuccess(context, 'Contact added successfully');
        Navigator.pop(context);
      }
    });

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
              'Add Trusted Contact',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Add your accountability partner',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                controller: _nameController,
                label: 'Full Name',
                hintText: 'Enter full name',
                prefixIcon: Icons.person_outline,
                validator: Validators.validateName,
              ),
              SizedBox(height: 20.h),
              CommonTextField(
                controller: _emailController,
                label: 'Email',
                hintText: 'Enter email address',
                prefixIcon: Icons.mail_outline,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),

              SizedBox(height: 28.h),
              Text(
                'Relationship',
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
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.black.withOpacity(0.02),
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
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: addContactState.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref
                                .read(addContactProvider.notifier)
                                .addContact(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  contact: '',
                                  relation: selectedRelation,
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: addContactState.isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
