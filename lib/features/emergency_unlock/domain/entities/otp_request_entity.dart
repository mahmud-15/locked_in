class OtpRequestEntity {
  final String appName;
  final String contactId;
  final String message;

  const OtpRequestEntity({
    required this.appName,
    required this.contactId,
    required this.message,
  });
}
