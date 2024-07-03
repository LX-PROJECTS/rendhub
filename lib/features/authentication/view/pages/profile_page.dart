import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent_hub/core/constants/icon_constants.dart';
import 'package:rent_hub/core/constants/authentication/profile_page_constants.dart';
import 'package:rent_hub/core/theme/app_theme.dart';
import 'package:rent_hub/features/ads/view/pages/history/history_details_page.dart';
import 'package:rent_hub/features/ads/view/pages/my_products_page.dart';
import 'package:rent_hub/features/authentication/controller/account_details_provider/account_details_provider.dart';
import 'package:rent_hub/features/authentication/controller/authenticcation_provider/authentication_provider.dart';
import 'package:rent_hub/features/authentication/view/pages/profile_settings_page.dart';
import 'package:rent_hub/features/authentication/view/widgets/profile_header_widget.dart';
import 'package:rent_hub/features/authentication/view/widgets/profile_option_tile_widget.dart';
import 'package:rent_hub/features/authentication/view/widgets/theme_switch_button.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});
  static const routePath = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(profilePageConstantsProvider);
    final userId = ref.watch(authenticationProvider).phoneNumber ?? "";
    final user = ref.watch(GetAccountDetailsProvider(userId: userId)).value;
    final profileImage = ref
            .watch(GetAccountDetailsProvider(
              userId: userId,
            ))
            .value
            ?.data()
            ?.profileImage ??
        ref.watch(iconConstantsProvider).icProfile;

    final themeSwitch = useState<bool>(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: context.spaces.space_800,
              color: context.colors.primary,
              child: Padding(
                padding: EdgeInsets.only(
                    right: context.spaces.space_300,
                    top: context.spaces.space_300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    ThemeSwitchButton(themeSwitch: themeSwitch),
                  ],
                ),
              ),
            ),
            ProfileHeaderWidget(
              name: user == null ? "" : user.data()?.userName ?? "",
              phone: userId,

              child: InkWell(
                onTap: () {
                  context.push(ProfileSettingsPage.routePath);
                },
                child: ClipOval(
                  child: Image.network(
                    fit: BoxFit.cover,
                    profileImage,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(ref.watch(iconConstantsProvider).icProfile),
                  ),
                ),
              ), //profile image
            ),
            Padding(
              padding: EdgeInsets.all(context.spaces.space_200),
              child: Column(
                children: [
                  ProfileOptionTile(
                    icon: Icons.assignment,
                    text: constants.txtMyAds,
                    onTap: () {
                      context.push(MyProductsPage.routePath);
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.history,
                    text: constants.txtOrderHistory,
                    onTap: () {
                      context.push(HistoryDetailsPage.routePath);
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.settings,
                    text: constants.txtAccountSettings,
                    onTap: () {
                      context.push(ProfileSettingsPage.routePath);
                    },
                  ),
                  ProfileOptionTile(
                    icon: Icons.help,
                    text: constants.txtHelpSupport,
                    subtitle: constants.txtsubHelp,
                    onTap: () {
                      // TODO : PRIVECY POLICY PAGE WANTED
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
