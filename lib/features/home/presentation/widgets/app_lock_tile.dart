import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/shared/widgets/app_icon_widget.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';

class AppLockTile extends ConsumerStatefulWidget {
  final LockedAppEntity item;

  const AppLockTile({super.key, required this.item});

  @override
  ConsumerState<AppLockTile> createState() => _AppLockTileState();
}

class _AppLockTileState extends ConsumerState<AppLockTile> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    _remaining = widget.item.lockUntil.difference(DateTime.now());
    if (_remaining.isNegative) _remaining = Duration.zero;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateRemaining();
        });
        if (_remaining == Duration.zero) {
          _timer?.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) return "$hours:$minutes:$seconds";
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () =>
            context.pushNamed(RouteNames.appLockedDetail, extra: widget.item),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              AppIconWidget(
                app: AppToLockEntity(
                  id: widget.item.id,
                  name: widget.item.name,
                  category: widget.item.category,
                  iconKey: widget.item.iconKey,
                  iconBytes: widget.item.iconBytes,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _AppInfo(
                  name: widget.item.name,
                  category: widget.item.category,
                ),
              ),
              _TimeBadge(duration: _formatDuration(_remaining)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  final String name;
  final String category;
  const _AppInfo({required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          category,
          style: const TextStyle(fontSize: 12, color: AppColors.gray),
        ),
      ],
    );
  }
}

class _TimeBadge extends StatelessWidget {
  final String duration;
  const _TimeBadge({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 14,
          color: AppColors.primary.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Text(
          duration,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primary.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
