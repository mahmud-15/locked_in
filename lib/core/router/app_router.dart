import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';
import 'package:locked_in/features/auth/presentation/screens/login_screen.dart';
import 'package:locked_in/features/auth/presentation/screens/register_screen.dart';
import 'package:locked_in/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:locked_in/features/create_lock/presentation/screens/create_lock_screen.dart';
import 'package:locked_in/features/emergency_unlock/presentation/screens/emergency_unlock_screen.dart';
import 'package:locked_in/features/emergency_unlock/domain/entities/emergency_unlock_args.dart';
import 'package:locked_in/features/tracking/presentation/screens/tracking_screen.dart';
import 'package:locked_in/features/home/presentation/screens/home_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/change_password_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/settings_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/subscription_history_screen.dart';
import 'package:locked_in/features/notifications/presentation/screens/notification_screen.dart';

import 'package:locked_in/features/settings/presentation/screens/payment_success_screen.dart';
import 'package:locked_in/features/splash/presentation/screens/splash_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/features/home/presentation/screens/app_locked_detail_screen.dart';

import 'package:locked_in/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:locked_in/features/onboarding/presentation/screens/onboarding_screen.dart';

import 'package:locked_in/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:locked_in/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:locked_in/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:locked_in/features/auth/presentation/screens/user_verify_screen.dart';
import 'package:locked_in/features/emergency_unlock/presentation/screens/request_code_screen.dart';
import 'package:locked_in/features/emergency_unlock/presentation/screens/request_sent_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/about_us_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/terms_condition_screen.dart';
import 'package:locked_in/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:locked_in/shared/widgets/common_bottom_nav_bar.dart';
import 'package:locked_in/features/settings/presentation/screens/subscription_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: Listenable.merge([
      RouterRefreshStream(ref.watch(authProvider.notifier).stream),
      RouterRefreshStream(ref.watch(onboardingProvider.notifier).stream),
    ]),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isOnboardingCompleted = ref.read(onboardingProvider);

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isInitial = authState.status == AuthStatus.initial;

      final isSplashing = state.matchedLocation == RoutePaths.splash;
      final isOnboarding = state.matchedLocation == RoutePaths.onboarding;
      final isAuthRoute =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.forgotPassword ||
          state.matchedLocation == RoutePaths.verifyOtp ||
          state.matchedLocation == RoutePaths.resetPassword ||
          state.matchedLocation == RoutePaths.userVerify;

      final isPublicPolicyRoute =
          state.matchedLocation == RoutePaths.termsCondition ||
          state.matchedLocation == RoutePaths.privacyPolicy ||
          state.matchedLocation == RoutePaths.aboutUs;

      // 1. Handle Splash Screen specifically
      if (isInitial) {
        return isSplashing ? null : RoutePaths.splash;
      }

      // If we are on Splash but state is now initialized, move forward
      if (isSplashing) {
        if (!isOnboardingCompleted) return RoutePaths.onboarding;
        if (!isAuthenticated) return RoutePaths.login;
        if (!authState.isSubscribed) return RoutePaths.subscription;
        return RoutePaths.home;
      }

      // 2. Handle Onboarding flow
      if (!isOnboardingCompleted) {
        return isOnboarding ? null : RoutePaths.onboarding;
      }

      // 3. Handle Auth Protected routes
      if (!isAuthenticated && !isAuthRoute && !isPublicPolicyRoute) {
        return RoutePaths.login;
      }

      // 4. Handle Subscription Requirement
      if (isAuthenticated && !authState.isSubscribed) {
        // Allow user verify screen if that's where they are coming from
        if (state.matchedLocation == RoutePaths.userVerify) return null;

        return state.matchedLocation == RoutePaths.subscription
            ? null
            : RoutePaths.subscription;
      }

      // 5. Handle Authenticated users trying to access Auth/Onboarding routes
      if (isAuthenticated && (isAuthRoute || isOnboarding)) {
        return authState.isSubscribed
            ? RoutePaths.home
            : RoutePaths.subscription;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.verifyOtp,
        name: RouteNames.verifyOtp,
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.userVerify,
        builder: (context, state) => const UserVerifyScreen(),
      ),
      // Nested Navigation with ShellRoute
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.contacts,
            name: RouteNames.contacts,
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: RoutePaths.tracking,
            name: RouteNames.tracking,
            builder: (context, state) => const TrackingScreen(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.createLock,
        name: RouteNames.createLock,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateLockScreen(),
      ),
      GoRoute(
        path: RoutePaths.aboutUs,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: RoutePaths.termsCondition,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TermsConditionScreen(),
      ),
      GoRoute(
        path: RoutePaths.privacyPolicy,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RoutePaths.emergencyUnlock,
        name: RouteNames.emergencyUnlock,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final lockedApp = state.extra as LockedAppEntity;
          return EmergencyUnlockScreen(lockedApp: lockedApp);
        },
      ),
      GoRoute(
        path: RoutePaths.subscription,
        name: RouteNames.subscription,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: RoutePaths.appLockedDetail,
        name: RouteNames.appLockedDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final app = state.extra as LockedAppEntity;
          return AppLockedDetailScreen(app: app);
        },
      ),
      GoRoute(
        path: RoutePaths.requestSent,
        name: RouteNames.requestSent,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as EmergencyUnlockArgs;
          return RequestSentScreen(args: args);
        },
      ),
      GoRoute(
        path: RoutePaths.requestCode,
        name: RouteNames.requestCode,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as EmergencyUnlockArgs;
          return RequestCodeScreen(args: args);
        },
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        name: RouteNames.editProfile,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.changePassword,
        name: RouteNames.changePassword,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.subscriptionHistory,
        name: RouteNames.subscriptionHistory,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SubscriptionHistoryScreen(),
      ),
      GoRoute(
        path: RoutePaths.paymentSuccess,
        name: RouteNames.paymentSuccess,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        name: RouteNames.notifications,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
});

class RouterRefreshStream extends ChangeNotifier {
  RouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Placeholder for Shell UI (Bottom Nav Bar etc)
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: child),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RoutePaths.home)) return 0;
    if (location.startsWith(RoutePaths.contacts)) return 1;
    if (location.startsWith(RoutePaths.tracking)) return 2;
    if (location.startsWith(RoutePaths.settings)) return 3;
    return 0;
  }
}
