import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';

class EmergencyUnlockScreen extends StatefulWidget {
  const EmergencyUnlockScreen({super.key});

  @override
  State<EmergencyUnlockScreen> createState() => _EmergencyUnlockScreenState();
}

class _EmergencyUnlockScreenState extends State<EmergencyUnlockScreen> {
  int selectedContactIndex = 0;
  String? selectedReason;

  final List<String> reasons = [
    'Urgent call & message',
    'Important work task',
    'Personal emergency',
    'Other reason',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
              'Emergency Unlock',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Request access from trusted contact',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request will be sent to',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF373737),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildContactList(),
                  SizedBox(height: 32.h),
                  Text(
                    'Why do you need emergency access? (optional)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF373737),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...reasons.map((reason) => _buildReasonItem(reason)),
                ],
              ),
            ),
          ),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildContactList() {
    return Column(
      children: List.generate(2, (index) {
        final isSelected = selectedContactIndex == index;
        return GestureDetector(
          onTap: () => setState(() => selectedContactIndex = index),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFEF2F1) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF5247)
                    : const Color(0xFFF1F5F9),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jane Doe',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF373737),
                      ),
                    ),
                    Text(
                      'Family',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF676E79),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReasonItem(String reason) {
    final isSelected = selectedReason == reason;
    return GestureDetector(
      onTap: () => setState(() => selectedReason = reason),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF5247)
                      : const Color(0xFFCBD5E1),
                  width: 1.5.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 11.w,
                        height: 11.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5247),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Text(
              reason,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF373737),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: () => context.pushNamed(RouteNames.requestSent),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5247),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Send Request',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
