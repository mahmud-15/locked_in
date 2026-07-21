/// Arguments passed between EmergencyUnlock → RequestSent → RequestCode screens.
class EmergencyUnlockArgs {
  final String appName;
  final String appId; // package name — used to unlock the app
  final String contactId;
  final String contactName;

  const EmergencyUnlockArgs({
    required this.appName,
    required this.appId,
    required this.contactId,
    required this.contactName,
  });
}
