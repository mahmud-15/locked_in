import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locked_in/core/utils/snackbar_utils.dart';
import 'package:locked_in/features/emergency_unlock/domain/entities/emergency_unlock_args.dart';
import 'package:locked_in/features/emergency_unlock/presentation/providers/verify_otp_provider.dart';
import 'package:locked_in/features/home/presentation/providers/home_notifier.dart';

class RequestCodeScreen extends ConsumerStatefulWidget {
  final EmergencyUnlockArgs args;

  const RequestCodeScreen({super.key, required this.args});

  @override
  ConsumerState<RequestCodeScreen> createState() => _RequestCodeScreenState();
}

class _RequestCodeScreenState extends ConsumerState<RequestCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  bool get _isCodeComplete => _otpCode.length == 4;

  void _submitOtp() {
    if (!_isCodeComplete) return;

    final otp = int.tryParse(_otpCode);
    if (otp == null) {
      AppSnackBar.showError(context, 'Please enter a valid numeric code');
      return;
    }

    ref
        .read(verifyOtpProvider.notifier)
        .verifyOtp(
          appName: widget.args.appName,
          contactId: widget.args.contactId,
          otp: otp,
        );
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(verifyOtpProvider);

    ref.listen(verifyOtpProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        AppSnackBar.showError(context, next.errorMessage!);
      } else if (next.isSuccess) {
        // Unlock the app and refresh home screen
        ref.read(homeProvider.notifier).unlockApp(widget.args.appId);

        AppSnackBar.showSuccess(
          context,
          next.successMessage ?? 'App unlocked successfully!',
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 104.w,
                height: 104.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 48.w,
                    color: const Color(0xFFFF5247),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Request Approved!',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF373737),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Enter the unlock code provided by ${widget.args.contactName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF676E79),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 100.h),
              Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF373737),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildCodeField(index)),
              ),
              const Spacer(flex: 3),
              _buildConfirmButton(otpState),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 80.w,
      height: 80.h,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF373737),
        ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFFF5247)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {}); // refresh button state
        },
      ),
    );
  }

  Widget _buildConfirmButton(VerifyOtpState otpState) {
    final canSubmit = _isCodeComplete && !otpState.isLoading;
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: canSubmit ? _submitOtp : null,
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
                'Confirm',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
