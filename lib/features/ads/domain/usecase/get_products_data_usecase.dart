import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_hub/core/exception/storage_exception/storage_exception.dart';
import 'package:rent_hub/core/utils/snakbar/show_snackbar.dart';
import 'package:rent_hub/features/ads/domain/model/ads_model.dart';
import 'package:rent_hub/features/ads/domain/usecase/get_category_usecase.dart';
import 'package:rent_hub/features/ads/service/fetch_all_products_data.dart';

// get Categarised products usecase
class GetProductsDataUsecase {
  Stream<List<AdsModel>> call(
      {required BuildContext context, String? catagory}) async* {
    // get catagory id with catagory name
    String catagoryId = '';
    if (catagory != null) {
      // fetch catagory data
      final catagoryData = await GetCategoryUseCase()();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> catagoryRef =
          catagoryData.docs.map((data) => data).toList();
      for (final data in catagoryRef) {
        if (data.data()['name'] == catagory) catagoryId = data.id;
      }
    }

    try {
      // fetch all products details
      final Stream<QuerySnapshot<AdsModel>> dataStream =
          FetchAllProductsData.FetchProducts();

      await for (var event in dataStream) {
        var allData = <AdsModel>[];
        for (var model in event.docs) {
          // yeild all products when category is null
          if (catagory == null) {
            allData.add(model.data());
          } else if (model.data().category == catagoryId) {
            // checks category id matches
            allData.add(model.data());
          }
        }

        yield allData;
      }
    } on StorageException catch (e) {
      // show snakbar when error
      context.showErrorSnackBar(e.message);
    }
  }
}
