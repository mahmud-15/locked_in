import 'package:flutter/material.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/home/presentation/utils/app_icon_mapper.dart';

class AppIconWidget extends StatelessWidget {
  final AppToLockEntity app;
  final double size;

  const AppIconWidget({super.key, required this.app, this.size = 42});

  @override
  Widget build(BuildContext context) {
    if (app.iconBytes != null) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: Image.memory(
          app.iconBytes!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _DefaultIcon(app: app, size: size),
        ),
      );
    }
    return _DefaultIcon(app: app, size: size);
  }
}

class _DefaultIcon extends StatelessWidget {
  final AppToLockEntity app;
  final double size;

  const _DefaultIcon({required this.app, required this.size});

  @override
  Widget build(BuildContext context) {
    final iconData = AppIconMapper.fromKey(app.iconKey);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: iconData.color, shape: BoxShape.circle),
      child: Icon(iconData.icon, color: Colors.white, size: size * 0.47),
    );
  }
}
