import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

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
              'Subscriptions History',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View your transaction history',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        itemCount: 8,
        itemBuilder: (context, index) {
          final isActive = index < 3;
          return _SubscriptionItem(isActive: isActive);
        },
      ),
    );
  }
}

class _SubscriptionItem extends StatelessWidget {
  final bool isActive;
  const _SubscriptionItem({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF2F1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFF9F43),
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Subscription',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF373737),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Purchased on Oct 12, 2024',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$49.00',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF373737),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFEEF9F1)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  isActive ? 'Active' : 'Expired',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
