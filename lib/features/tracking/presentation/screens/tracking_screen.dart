import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const CommonText(
          'Reports',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartCard(),
            SizedBox(height: 24.h),
            const CommonText(
              'Most Used Apps',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            SizedBox(height: 16.h),
            _buildAppUsageCard(
              iconData: Icons.flutter_dash, // Placeholder for Twitter
              iconColor: const Color(0xFF1DA1F2),
              name: 'Twitter',
              subtitle: '45 mins • 4/10 Opens',
              percentage: 45,
            ),
            SizedBox(height: 12.h),
            _buildAppUsageCard(
              iconData: Icons.play_circle_fill, // Placeholder for YouTube
              iconColor: const Color(0xFFFF0000),
              name: 'YouTube',
              subtitle: '45 mins • 4/10 Opens',
              percentage: 45,
            ),
            SizedBox(height: 12.h),
            _buildAppUsageCard(
              iconData: Icons.facebook,
              iconColor: const Color(0xFF1877F2),
              name: 'Facebook',
              subtitle: '45 mins • 4/10 Opens',
              percentage: 45,
            ),
            SizedBox(height: 12.h),
            _buildAppUsageCard(
              iconData: Icons.facebook,
              iconColor: const Color(0xFF1877F2),
              name: 'Facebook',
              subtitle: '45 mins • 4/10 Opens',
              percentage: 45,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                'Daily Usage',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              Row(
                children: [
                  const CommonText(
                    'Today',
                    fontSize: 14,
                    color: AppColors.gray,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.gray,
                    size: 20.sp,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 160.h,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double availableHeight =
                    constraints.maxHeight -
                    32.h; // Reserve space for icon and spacing
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(
                      maxHeight: availableHeight,
                      percentage: 0.45,
                      color: AppColors.primary.withOpacity(0.8),
                      iconData: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                    ),
                    _buildBar(
                      maxHeight: availableHeight,
                      percentage: 0.59,
                      color: AppColors.primary,
                      iconData: Icons.camera_alt,
                      iconColor: const Color(0xFFE1306C),
                    ),
                    _buildBar(
                      maxHeight: availableHeight,
                      percentage: 0.19,
                      color: AppColors.primary.withOpacity(0.5),
                      iconData: Icons.chat_bubble,
                      iconColor: const Color(0xFFFFFC00),
                    ),
                    _buildBar(
                      maxHeight: availableHeight,
                      percentage: 0.09,
                      color: AppColors.primary.withOpacity(0.3),
                      iconData: Icons.movie,
                      iconColor: const Color(0xFFE50914),
                    ),
                    _buildBar(
                      maxHeight: availableHeight,
                      percentage: 0.72,
                      color: AppColors.primary,
                      iconData: Icons.music_note,
                      iconColor: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({
    required double maxHeight,
    required double percentage,
    required Color color,
    required IconData iconData,
    required Color iconColor,
  }) {
    final int labelValue = (percentage * 100).toInt();
    final double barHeight = maxHeight * percentage;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 32.w,
            height: barHeight > 0 ? barHeight : 0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              child: Text('$labelValue%'),
            ),
          ),
          SizedBox(height: 8.h),
          CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.white,
            child: Icon(iconData, color: iconColor, size: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageCard({
    required IconData iconData,
    required Color iconColor,
    required String name,
    required String subtitle,
    required int percentage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20.r,
            child: Icon(iconData, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  name,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 4.h),
                CommonText(subtitle, fontSize: 12, color: AppColors.gray),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.w,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  strokeWidth: 3,
                ),
              ),
              CommonText(
                '$percentage%',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
