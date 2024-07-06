import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_hub/core/constants/ads/product_screen.dart';
import 'package:rent_hub/core/theme/app_theme.dart';
import 'package:rent_hub/core/theme/color_palette.dart';
import 'package:rent_hub/core/widgets/main_btn_widget.dart';
import 'package:rent_hub/core/widgets/rounded_btn_widget.dart';
import 'package:rent_hub/features/ads/controller/product_controller/product_controller.dart';
import 'package:rent_hub/features/ads/controller/user_controller/user_data_provider.dart';
import 'package:rent_hub/features/ads/domain/model/ads_model/ads_model.dart';
import 'package:rent_hub/features/ads/view/widgets/product_details/prodcut_details_widget.dart';
import 'package:rent_hub/features/ads/view/widgets/product_details/smooth_page_Indicator_wIdget.dart';
import 'package:rent_hub/features/favorites/controller/favorite_ads_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Main widget that displays the product details page
class ProductDetailsPage extends ConsumerWidget {
  static const routePath = '/productsDetails';

  const ProductDetailsPage({
    super.key,
    required this.adsData,
  });

  final QueryDocumentSnapshot<AdsModel> adsData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(adsData.data().sellerId)).when(
            data: (data) => FutureBuilder(
                future:
                    ref.watch(favoriteAdsProvider.notifier).isFav(adsData.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      child: Text('ERROR'),
                    );
                  }

                  /// snapshot has no data return circular indicator
                  if (!snapshot.hasData) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      // PageView to show images
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.42,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: ref.watch(pageControllerProvider),
                          itemBuilder: (context, index) => Image.network(
                            adsData.data().imagePath[index],
                          ),
                          itemCount: adsData.data().imagePath.length,
                        ),
                      ),
                      // top bar icons
                      Positioned(
                        top: 28.0,
                        left: 16.0,
                        right: 16.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedIconButton(
                              onTap: () {
                                context.pop();
                              },
                              icon: Icons.chevron_left,
                            ),
                            RoundedIconButton(
                              onTap: () async {
                                /// toggle favorite status
                                /// invalidate provider for rebuild ui
                                await ref
                                    .watch(favoriteAdsProvider.notifier)
                                    .setFavorite(adId: adsData.id);
                                ref.invalidate(getUserDataProvider);
                              },
                              icon: Icons.favorite,
                              iconColor: snapshot.data!
                                  ? AppColorPalettes.red500
                                  : AppColorPalettes.black500,
                            ),
                          ],
                        ),
                      ),
                      // SmoothPageIndicator to show the current page
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.34,
                        right: 16.0,
                        left: 16.0,
                        child: SmoothPageIndicatorWIdget(
                            imageCount: adsData.data().imagePath.length),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.36,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ProductDetailsWidget(
                            price: adsData.data().price,
                            userimage: data.data()?.profileImage,
                            onwername: data.data()!.userName,
                            productname: adsData.data().productName,
                            location: adsData.data().locationTitle,
                            productdetails: adsData.data().description ?? '',
                            callTap: () async {
                              await launchUrlString("tel:${data.id}");
                            },
                            chatTap: () {
                              // TODO : Navigate seller chat page
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(error.toString()),
                  // height spacer
                  SizedBox(height: context.spaces.space_200),
                  IconButton(
                    onPressed: () {
                      ref.invalidate(getUserDataProvider);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: MainBtnWidget(
          onTap: () {},
          btnTxt: ref.read(productScreenConstantsProvider).txtbtn,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
