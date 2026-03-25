import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/theme/app_colors.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = [
      _NavItem(
        title: 'Home',
        unselectedIcon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: RoutePaths.home,
      ),
      _NavItem(
        title: 'Contacts',
        unselectedIcon: Icons.people_outline,
        selectedIcon: Icons.people,
        route: RoutePaths.contacts,
      ),
      _NavItem(
        title: 'Tracking',
        unselectedIcon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
        route: RoutePaths.tracking,
      ),
      _NavItem(
        title: 'Settings',
        unselectedIcon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: RoutePaths.settings,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFECECEC), width: 1.w),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 79.h, // Exact height from Figma
          padding: EdgeInsets.symmetric(
            horizontal: 43.w,
          ), // Exact side padding from Figma
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Exact justify from Figma
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () {
                  if (!isSelected) {
                    context.go(item.route);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  // The 17px vertical padding is handled by the 79px height + internal alignment
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.selectedIcon : item.unselectedIcon,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFBCBCBC),
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      CommonText(
                        item.title,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFBCBCBC),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String title;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String route;

  _NavItem({
    required this.title,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.route,
  });
}
