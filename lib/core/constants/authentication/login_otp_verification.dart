import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_otp_verification.g.dart';

class LoginOtpVerificationConstants {
  final txtHeading = "OTP Verification";
  final txtSubHeading =
      "Enter the verification code we just sent to your number ";
  final txtRetryBtn = "Retry";
}

@riverpod
LoginOtpVerificationConstants loginOtpVerificationConstants(
    LoginOtpVerificationConstantsRef ref) {
  return LoginOtpVerificationConstants();
}
