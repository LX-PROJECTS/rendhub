import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otp_text_field/style.dart';
import 'package:rent_hub/core/constants/image_constants.dart';
import 'package:rent_hub/core/constants/authentication/login_otp_verification.dart';
import 'package:rent_hub/core/theme/app_theme.dart';
import 'package:rent_hub/core/widgets/main_btn_widget.dart';
import 'package:rent_hub/features/authentication/controller/authenticcation_provider/authentication_provider.dart';
import 'package:rent_hub/features/authentication/view/pages/login_page.dart';
import 'package:rent_hub/features/authentication/view/widgets/otp_textfeild_widget.dart';

class OtpVerificationPage extends HookConsumerWidget {
  static const routePath = '/otpvarificationpage';

  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<bool> isFilled = List.filled(6, false);

    // otp pin text controller
    final otpPin = useState('');

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SvgPicture.asset(
            ref.watch(imageConstantsProvider).imgOtpGirl,
            width: 220,
          ),
          Text(
            ref.watch(loginOtpVerificationConstantsProvider).txtHeading,
            style: context.typography.h2SemiBold,
          ),
          SizedBox(height: context.spaces.space_200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spaces.space_200),
            child: Text(
              "${ref.watch(loginOtpVerificationConstantsProvider).txtSubHeading} ${ref.watch(authenticationProvider).phoneNumber}",
              style: context.typography.body,
            ),
          ),
          SizedBox(height: context.spaces.space_250),
          OtpTextFeildWidget(
            onCompleted: (pin) {
              // whent otp entered completed
              ref.read(authenticationProvider.notifier).verifyOtp(smsCode: pin);
            },
            isFilled: isFilled,
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: context.spaces.space_125 * 5.5,
            style: context.typography.bodyLarge,
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onChanged: (String value) {
              otpPin.value = value;
            },
          ),
          SizedBox(height: context.spaces.space_200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spaces.space_200),
            child: MainBtnWidget(
              isLoading: ref.read(authenticationProvider).isLoading,
              onTap: () {
                context.push(LoginPage.routePath);
              },
              btnTxt:
                  ref.watch(loginOtpVerificationConstantsProvider).txtRetryBtn,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
