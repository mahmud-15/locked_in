import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanEntity plan;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    required this.onJoin,
  });

  Color get _tierColor {
    final name = plan.name.toLowerCase();
    if (name.contains('starter')) {
      return const Color(0xFF676E79);
    } else if (name.contains('pro')) {
      return AppColors.primary;
    } else if (name.contains('elite')) {
      return const Color(0xFF9C27B0);
    } else {
      return AppColors.primary;
    }
  }

  Color get _cardBackground {
    final name = plan.name.toLowerCase();
    if (name.contains('starter')) {
      return Colors.white;
    } else if (name.contains('pro')) {
      return const Color(0xFFFFF7F6);
    } else if (name.contains('elite')) {
      return const Color(0xFFF9F2FF);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? _tierColor : _tierColor.withOpacity(0.1),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: _tierColor.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (plan.isPopular)
              Positioned(
                top: 0,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _tierColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: _tierColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        plan.price,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        plan.billingCycle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF676E79),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    plan.tagline,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF676E79).withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Divider(
                      color: _tierColor.withOpacity(0.1),
                      thickness: 1,
                    ),
                  ),
                  ...plan.features.map(
                    (f) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: _tierColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: _tierColor,
                              size: 14.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF373737),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: onJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.white : _tierColor,
                        foregroundColor: isSelected ? _tierColor : Colors.white,
                        elevation: 0,
                        side: isSelected
                            ? BorderSide(color: _tierColor, width: 2)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        isSelected ? 'Current Plan' : 'Choose Plan',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
