class ApiEndpoints {
  static const String baseUrl = 'http://13.62.231.71:5006/api/v1';
  static const String login = '/auth/login';
  static const String register = '/user';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-otp';
  static const String profile = '/user/profile';
  static const String changePassword = '/auth/change-password';
  static const String plan = '/plan';
  static const String disclaimer = '/disclaimer';
  static const String subscriptionStripe = '/subscription/stripe';
  static const String subscriptionHistory =
      '/subscription/subscription-history';
}
