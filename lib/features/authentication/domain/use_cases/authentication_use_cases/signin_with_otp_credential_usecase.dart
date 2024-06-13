import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_hub/core/exception/authentication_exception/otp_verify_exception.dart';
import 'package:rent_hub/features/authentication/service/authentication_service.dart';
import 'package:rent_hub/features/authentication/service/shared_perf_service.dart';

final class SigninWithOtpCredentialUseCase {
  //log in with credintial
  Future<UserCredential> call({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      //phone number auth credential
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential = await AuthenticationService
          .firebaseAuthInstance
          .signInWithCredential(phoneAuthCredential);

      // save user already logged
      if (userCredential.user != null) {
        final perf = await SharedPerfService.get();
        perf.setBool('isLogged', true);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw VerifyOTPException(
        error: e.message,
      );
    }
  }
}
