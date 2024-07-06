import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent_hub/core/constants/authentication/create_account.dart';
import 'package:rent_hub/core/theme/app_theme.dart';
import 'package:rent_hub/core/widgets/main_btn_widget.dart';
import 'package:rent_hub/core/widgets/textfeild_widget.dart';
import 'package:rent_hub/features/authentication/controller/account_details_provider/account_details_provider.dart';
import 'package:rent_hub/features/authentication/controller/authenticcation_provider/authentication_provider.dart';
import 'package:rent_hub/features/authentication/controller/image_picker_provider.dart';
import 'package:rent_hub/features/authentication/view/widgets/profile_image_selector_widget.dart';

class CreateAccountPage extends HookConsumerWidget {
  static const routePath = '/createAccount';

  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createAcConst = ref.watch(createAccountConstantProvider);

    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spaces.space_200,
          ),
          child: ref.watch(getUserDetailsProvider).when(
                data: (data) {
                  // name text editing controller
                  final nameEditingController = useTextEditingController(
                    text: data.data()?.userName ?? "",
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 4),
                      Text(
                        createAcConst.txtHeading,
                        style: context.typography.h1SemiBold,
                      ),
                      Spacer(flex: 2),
                      ProfileImageSelectorWidget(
                        imageDbRef: data.data()?.profileImage ?? '',
                      ),
                      Spacer(flex: 1),
                      // user name field
                      Form(
                        key: _formKey,
                        child: TextFeildWidget(
                          labeltxt: createAcConst.txtLabelName,
                          hinttxt: createAcConst.txtHintName,
                          textController: nameEditingController,
                          validator: (value) {
                            if (nameEditingController.text.isEmpty) {
                              return 'Enter Your Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          createAcConst.txtSubtitle,
                          style: context.typography.bodySmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: context.spaces.space_200),
                        child: MainBtnWidget(
                          isLoading: ref.watch(accountDetailsProvider),
                          onTap: () {
                            // name TextEditingController validation
                            if (_formKey.currentState!.validate()) {
                              // add user data
                              ref.read(accountDetailsProvider.notifier).addData(
                                    userId: ref
                                        .read(authenticationProvider)
                                        .phoneNumber!,
                                    userName: nameEditingController.text,
                                    image: ref.read(imagePickerProvider),
                                  );
                            }
                          },
                          btnTxt: createAcConst.txtbtn,
                        ),
                      ),
                      const Spacer(flex: 6),
                    ],
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        createAcConst.txtError,
                        style: context.typography.body,
                      ),
                      IconButton(
                        onPressed: () {
                          ref.invalidate(getUserDetailsProvider);
                        },
                        icon: Icon(Icons.replay_rounded),
                      )
                    ],
                  ),
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
      ),
    );
  }
}
