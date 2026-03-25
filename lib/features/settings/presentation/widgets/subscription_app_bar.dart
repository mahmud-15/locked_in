import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';

class SubscriptionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SubscriptionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.black,
          size: 20,
        ),
      ),
      centerTitle: false,
      title: const _AppBarTitle(),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Text(
          'Choose your plan',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
