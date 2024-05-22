import 'package:rent_hub/core/exception/base_exception/base_exception.dart';

final class VerifyOTPException extends BaseException {
  final int? statusCode;
  final String? error;
  final String? responseMessage;
  VerifyOTPException({this.statusCode, this.error, this.responseMessage})
      : super(
            message: statusCode == null
                ? error ??
                    "Some unknown issue occurred. Check your internet connection and try again."
                : responseMessage ??
                    "OTP verification failed with statusCode $statusCode. Please request again.");
}
