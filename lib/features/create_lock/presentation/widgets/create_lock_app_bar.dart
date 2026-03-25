import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/router/route_names.dart';

class CreateLockAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateLockAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(RouteNames.home);
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.black,
          size: 20,
        ),
      ),
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
          'Select App',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Text(
          'Choose apps to lock',
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
