import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/settings/presentation/providers/subscription_notifier.dart';
import 'package:locked_in/features/settings/presentation/providers/subscription_state.dart';
import 'package:locked_in/features/settings/presentation/widgets/plan_card.dart';
import 'package:locked_in/features/settings/presentation/widgets/subscription_app_bar.dart';
import 'package:locked_in/features/settings/presentation/widgets/stripe_web_view.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SubscriptionAppBar(),
      body: Stack(
        children: [
          _buildBody(context, ref, state),
          if (state.isSubscribing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSubscribe(
    BuildContext context,
    WidgetRef ref,
    String planId,
  ) async {
    final url = await ref
        .read(subscriptionProvider.notifier)
        .initiateSubscription(planId);

    if (url != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StripeWebView(
            url: url,
            onPaymentSuccess: () {
              ref.read(subscriptionProvider.notifier).onPaymentSuccess();
              Navigator.pop(context); // Close webview
              context.goNamed(RouteNames.paymentSuccess);
            },
          ),
        ),
      );
    }
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SubscriptionState state,
  ) {
    if (state.status == SubscriptionStatus.loading ||
        state.status == SubscriptionStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == SubscriptionStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Something went wrong',
          style: const TextStyle(color: AppColors.gray),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: state.plans.length,
      itemBuilder: (_, i) {
        final plan = state.plans[i];
        return PlanCard(
          plan: plan,
          isSelected: state.activePlanId == plan.id,
          onTap: () =>
              ref.read(subscriptionProvider.notifier).selectPlan(plan.id),
          onJoin: () => _handleSubscribe(context, ref, plan.id),
        );
      },
    );
  }
}
