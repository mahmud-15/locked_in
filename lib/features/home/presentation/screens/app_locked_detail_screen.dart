import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/shared/widgets/app_icon_widget.dart';

class AppLockedDetailScreen extends StatefulWidget {
  final LockedAppEntity app;

  const AppLockedDetailScreen({super.key, required this.app});

  @override
  State<AppLockedDetailScreen> createState() => _AppLockedDetailScreenState();
}

class _AppLockedDetailScreenState extends State<AppLockedDetailScreen> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    _remaining = widget.app.lockUntil.difference(DateTime.now());
    if (_remaining.isNegative) _remaining = Duration.zero;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _calculateRemaining());
        if (_remaining == Duration.zero) _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
    }
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final appEntity = AppToLockEntity(
      id: widget.app.id,
      name: widget.app.name,
      category: widget.app.category,
      iconKey: widget.app.iconKey,
      iconBytes: widget.app.iconBytes,
    );

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

              // ─── App Icon with lock badge ─────────────────────────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 160.w,
                    height: 160.w,
                    padding: EdgeInsets.all(24.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF2F1),
                      shape: BoxShape.circle,
                    ),
                    child: AppIconWidget(app: appEntity, size: 112.w),
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

              // ─── App name ─────────────────────────────────────────────
              Text(
                '${widget.app.name} is Locked',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF373737),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              Text(
                widget.app.category,
                style: TextStyle(fontSize: 13.sp, color: AppColors.gray),
              ),

              SizedBox(height: 48.h),

              // ─── Countdown section ────────────────────────────────────
              Text(
                'This app will be available in:',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF676E79),
                ),
              ),

              SizedBox(height: 20.h),

              _CountdownDisplay(
                remaining: _remaining,
                formattedTime: _formatDuration(_remaining),
                lockUntil: widget.app.lockUntil,
              ),

              const Spacer(),

              // ─── Emergency unlock ─────────────────────────────────────
              _EmergencyUnlockButton(
                onPressed: () => context.pushNamed(
                  RouteNames.emergencyUnlock,
                  extra: widget.app,
                ),
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Countdown Display ────────────────────────────────────────────────────────

class _CountdownDisplay extends StatelessWidget {
  final Duration remaining;
  final String formattedTime;
  final DateTime lockUntil;

  const _CountdownDisplay({
    required this.remaining,
    required this.formattedTime,
    required this.lockUntil,
  });

  String _unlockTimeLabel(DateTime lockUntil) {
    final hour = lockUntil.hour;
    final minute = lockUntil.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return 'Unlocks at $displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (remaining == Duration.zero) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 0.5.w),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 36.sp),
            SizedBox(height: 8.h),
            Text(
              'Lock Expired',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

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
                formattedTime,
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _unlockTimeLabel(lockUntil),
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF676E79)),
          ),
        ],
      ),
    );
  }
}

// ─── Emergency Unlock Button ──────────────────────────────────────────────────

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
