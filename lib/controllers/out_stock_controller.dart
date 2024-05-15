import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/app_constants.dart';
import 'base_controller.dart';

class OutStockController extends BaseController {
  final quantityController = TextEditingController();

  String? selectedConcept;
  Product? product;

  final List<String> conceptOptions = [
    'Sale',
    'Transfer',
    'Returns to suppliers',
    'Loss, theft, damage, etc.',
  ];

  OutStockController(super.repository, super.sharedPreferences);

  addProduct(Product p) {
    product = p;
    notifyListeners();
  }

  Future<void> submitData(context) async {
    int quantity = int.parse("0${quantityController.text}");

    if (quantity > 0 && product != null) {
      var response = await repository.authorizedPost(
        '${AppConstants.urlBase}/api/inventory/output',
        <String, dynamic>{
          'product': product?.id,
          'quantity': quantity,
          'concept': selectedConcept!,
          'store': AppConstants.branchIdDailyStop
        },
      );

      if (response.statusCode == 200) {
        showMessageDialog(
            context, 'The out inventory was successfully registered.');
      } else {
        showMessageDialog(context, 'The out inventory could not be recorded.');
      }
    } else {
      showMessageDialog(context, "Error!!");
    }
  }
}
