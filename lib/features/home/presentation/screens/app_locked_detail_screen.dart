import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/features/home/presentation/utils/app_icon_mapper.dart';

class AppLockedDetailScreen extends StatelessWidget {
  final LockedAppEntity app;

  const AppLockedDetailScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final iconData = AppIconMapper.fromKey(app.iconKey);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF373737)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 160.w,
                    height: 160.w,
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        iconData.icon,
                        size: 80.w,
                        color: iconData.color,
                      ),
                    ),
                  ),
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_outline,
                        size: 18.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                '${app.name} is Locked',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF373737),
                ),
              ),
              SizedBox(height: 100.h),
              Text(
                'This app will be available in:',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF676E79),
                ),
              ),
              SizedBox(height: 20.h),
              _TimerDisplay(durationText: app.lockedDuration),
              const Spacer(),
              _EmergencyUnlockButton(
                onPressed: () => context.pushNamed(RouteNames.emergencyUnlock),
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final String durationText;

  const _TimerDisplay({required this.durationText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFECACA), width: 0.5.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time, color: AppColors.primary, size: 28),
              SizedBox(width: 8.w),
              Text(
                durationText,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '52s',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF676E79)),
          ),
        ],
      ),
    );
  }
}

class _EmergencyUnlockButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _EmergencyUnlockButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 54.h),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF676E79)),
          SizedBox(width: 10.w),
          Text(
            'Emergency Unlock',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF676E79),
            ),
          ),
        ],
      ),
    );
  }
}
