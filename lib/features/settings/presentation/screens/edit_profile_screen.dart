import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/features/settings/presentation/providers/profile_notifier.dart';
import 'package:locked_in/shared/widgets/common_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Pre-fill if data is already available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileNotifierProvider);
      if (profileState.user != null) {
        _nameController.text = profileState.user?.name ?? '';
        _emailController.text = profileState.user?.email ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    // Listen for state changes to update controllers if they were empty
    ref.listen(profileNotifierProvider, (previous, next) {
      if (next.user != null && _nameController.text.isEmpty) {
        _nameController.text = next.user?.name ?? '';
        _emailController.text = next.user?.email ?? '';
      }
    });

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
              'Profile Details',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View your details',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body:
          profileState.status == ProfileStatus.loading &&
              profileState.user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextField(
                    label: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    readOnly: true,
                    enabled: false,
                  ),
                  SizedBox(height: 24.h),
                  CommonTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    readOnly: true,
                    enabled: false,
                  ),
                ],
              ),
            ),
    );
  }
}
