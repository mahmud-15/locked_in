import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';
import 'package:locked_in/features/settings/presentation/widgets/plan_feature_item.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlanEntity plan;
  final bool isSelected;
  final VoidCallback onJoin;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onJoin,
  });

  /// Only the plan NAME text color differs per tier — everything else is unified
  Color get _titleColor {
    switch (plan.id) {
      case 'premium':
        return const Color(0xFFFF8C00);
      case 'diamond':
        return const Color(0xFFE53935);
      default:
        return AppColors.primary;
    }
  }

  /// Very light tint behind each card to differentiate tiers subtly
  Color get _cardTint {
    switch (plan.id) {
      case 'premium':
        return const Color(0xFFFFF8F0);
      case 'diamond':
        return const Color(0xFFFFF3F3);
      default:
        return const Color(0xFFFFF5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _cardTint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? _titleColor : _titleColor.withOpacity(0.18),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _titleColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanHeader(plan: plan, titleColor: _titleColor),
            const Divider(height: 24, thickness: 0.8, color: Color(0xFFEEEEEE)),
            ...plan.features.map((f) => PlanFeatureItem(feature: f)),
            const SizedBox(height: 18),
            _JoinButton(onTap: onJoin),
          ],
        ),
      ),
    );
  }
}

// ─── Plan Header ─────────────────────────────────────────────────────────────

class _PlanHeader extends StatelessWidget {
  final SubscriptionPlanEntity plan;
  final Color titleColor;

  const _PlanHeader({required this.plan, required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plan.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              plan.price,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              plan.billingCycle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.gray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          plan.tagline,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.gray.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

// ─── Join Button — always primary red ────────────────────────────────────────

class _JoinButton extends StatelessWidget {
  final VoidCallback onTap;

  const _JoinButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // ← always same red
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Join',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
