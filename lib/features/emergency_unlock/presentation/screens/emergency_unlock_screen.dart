import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/core/utils/snackbar_utils.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
import 'package:locked_in/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:locked_in/features/emergency_unlock/domain/entities/emergency_unlock_args.dart';
import 'package:locked_in/features/emergency_unlock/presentation/providers/request_otp_provider.dart';

import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';

class EmergencyUnlockScreen extends ConsumerStatefulWidget {
  final LockedAppEntity lockedApp;
  const EmergencyUnlockScreen({super.key, required this.lockedApp});

  @override
  ConsumerState<EmergencyUnlockScreen> createState() =>
      _EmergencyUnlockScreenState();
}

class _EmergencyUnlockScreenState extends ConsumerState<EmergencyUnlockScreen> {
  String? selectedContactId;
  String? selectedReason;

  final List<String> reasons = [
    'Urgent call or message',
    'Important work task',
    'Personal emergency',
    'Other reason',
  ];

  @override
  Widget build(BuildContext context) {
    final contactsState = ref.watch(contactsProvider);

    ref.listen(requestOtpProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.showError(context, next.errorMessage!);
      } else if (next.isSuccess && selectedContactId != null) {
        final selectedContact = contactsState.contacts.firstWhere(
          (c) => c.id == selectedContactId,
        );
        context.pushReplacementNamed(
          RouteNames.requestSent,
          extra: EmergencyUnlockArgs(
            appName: widget.lockedApp.name,
            appId: widget.lockedApp.id,
            contactId: selectedContactId!,
            contactName: selectedContact.name,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF373737)),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 70.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Unlock',
              style: TextStyle(
                color: const Color(0xFF373737),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Request access from trusted contact',
              style: TextStyle(
                color: const Color(0xFF676E79),
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request will be sent to',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF373737),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ─── Contact List ─────────────────────────────────────
                  if (contactsState.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF5247),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else if (contactsState.contacts.isEmpty)
                    _NoContactsPlaceholder()
                  else
                    ...contactsState.contacts.map(
                      (contact) => _ContactCard(
                        contact: contact,
                        isSelected: selectedContactId == contact.id,
                        onTap: () =>
                            setState(() => selectedContactId = contact.id),
                      ),
                    ),

                  SizedBox(height: 32.h),

                  Text(
                    'Why do you need emergency access? (optional)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF373737),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...reasons.map((reason) => _buildReasonItem(reason)),
                ],
              ),
            ),
          ),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildReasonItem(String reason) {
    final isSelected = selectedReason == reason;
    return GestureDetector(
      onTap: () => setState(() => selectedReason = reason),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5247)
                : const Color(0xFFF1F5F9),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF5247)
                      : const Color(0xFFCBD5E1),
                  width: 1.5.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 11.w,
                        height: 11.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5247),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Text(
              reason,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF373737),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final otpState = ref.watch(requestOtpProvider);
    final canSend = selectedContactId != null && !otpState.isLoading;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: canSend
              ? () {
                  ref
                      .read(requestOtpProvider.notifier)
                      .sendRequest(
                        appName: widget.lockedApp.name,
                        contactId: selectedContactId!,
                        message: selectedReason ?? '',
                      );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5247),
            disabledBackgroundColor: otpState.isLoading
                ? const Color(0xFFFF5247)
                : const Color(0xFFFF5247).withOpacity(0.4),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: otpState.isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Send Request',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Contact Card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final ContactEntity contact;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactCard({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF8B5CF6),
      Color(0xFF2563EB),
      Color(0xFF059669),
      Color(0xFFD97706),
      Color(0xFFDC2626),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF2F1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5247)
                : const Color(0xFFF1F5F9),
            width: isSelected ? 1.5.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFFF5247).withOpacity(0.06)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: _avatarColor(contact.name),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                _initials(contact.name),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF373737),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    contact.relation,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF676E79),
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            if (isSelected)
              Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5247),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 14.sp),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── No Contacts Placeholder ──────────────────────────────────────────────────

class _NoContactsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.group_outlined,
            size: 40.sp,
            color: const Color(0xFFCBD5E1),
          ),
          SizedBox(height: 12.h),
          Text(
            'No trusted contacts added yet',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF676E79)),
          ),
          SizedBox(height: 4.h),
          Text(
            'Add a contact from the Contacts tab',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }
}
