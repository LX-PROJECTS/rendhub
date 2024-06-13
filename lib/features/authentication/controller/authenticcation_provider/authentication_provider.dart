import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_hub/core/exception/base_exception/base_exception.dart';
import 'package:rent_hub/core/utils/snakbar/error_snackbar.dart';
import 'package:rent_hub/features/authentication/controller/authenticcation_provider/authentication_state.dart';
import 'package:rent_hub/features/authentication/domain/use_cases/authentication_use_cases/log_out_use_case.dart';
import 'package:rent_hub/features/authentication/domain/use_cases/authentication_use_cases/signin_with_otp_credential_usecase.dart';
import 'package:rent_hub/features/authentication/domain/use_cases/authentication_use_cases/verify_phone_number_use_case.dart';
import 'package:rent_hub/features/authentication/view/pages/create_account_page.dart';
import 'package:rent_hub/features/authentication/view/pages/login_page.dart';
import 'package:rent_hub/features/authentication/view/pages/otp_verification_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

// authentication verification

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  AuthenticationState build() {
    return const AuthenticationState(
      isLoading: false,
      phoneNumber: null,
      verificationId: null,
    );
  }

  // phone number verification
  Future<void> verifyPhoneNuber(BuildContext context,
      {required String phoneNumber}) async {
    state = state.copyWith(isLoading: true, phoneNumber: phoneNumber);

    try {
      await VerifyPhoneNumberUseCase()(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          state = state.copyWith(verificationId: verificationId);
        },
      );

      state = state.copyWith(isLoading: false);

      // navigate otp page
      context.pushReplacement(OtpVerificationScreen.routePath);
    } on BaseException catch (e) {
      state = state.copyWith(isLoading: false);

      Future.sync(
        () => ErrorSnackBar(context, errorMessage: e.message),
      );
    }
    state = state.copyWith(isLoading: false);
  }

  // otp verification
  Future<void> otpVerification(
    BuildContext context, {
    required String smsCode,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      if (state.verificationId != null) {
        final userCredential = await SigninWithOtpCredentialUseCase()(
          verificationId: state.verificationId!,
          smsCode: smsCode,
        );

        state = state.copyWith(isLoading: false);

        // if user is logged push home page
        if (userCredential.user != null) {
          //? navigate home page
          context.pushReplacement(CreateAccountPage.routePath);
        } else {
          Future.sync(
            () => ErrorSnackBar(
              context,
              errorMessage: 'otp verification faild retry',
            ),
          );
        }
      } else {
        state = state.copyWith(isLoading: false);

        // if is verification id faild
        Future.sync(
          () => ErrorSnackBar(
            context,
            errorMessage: 'A error occured phone number verification, retry',
          ),
        );
      }
    } on BaseException catch (e) {
      state = state.copyWith(isLoading: false);

      Future.sync(
        () => ErrorSnackBar(context, errorMessage: e.message),
      );
    }
    state = state.copyWith(isLoading: false);
  }

  // logout
  Future<void> logoutUser(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    try {
      await LogOutUseCase()();

      // navigate to login page
      context.go(LoginPage.routePath);

      state = state.copyWith(isLoading: false);
    } on BaseException catch (e) {
      state = state.copyWith(isLoading: false);

      Future.sync(
        () => ErrorSnackBar(context, errorMessage: e.message),
      );
    }

    state = state.copyWith(isLoading: false);
  }
}

// country code provider
final coutryCodeProvider = StateProvider<String>(
  (ref) => '+91',
);
