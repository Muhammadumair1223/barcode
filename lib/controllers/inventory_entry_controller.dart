import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../utils/app_constants.dart';
import 'base_controller.dart';

class InventoryEntryController extends BaseController {
  final quantityController = TextEditingController();

  String? selectedConcept;

  final List<String> conceptOptions = [
    'Receive',
  ];

  InventoryEntryController(super.repository, super.sharedPreferences);

  Future<void> submitData(context) async {
    int quantity = int.tryParse(quantityController.text) ?? 0;

    String concept = selectedConcept!;

    if (quantity > 0 && concept.isNotEmpty && productNotifier.value != null) {
      http.Response response = await repository.authorizedPost(
        '${AppConstants.urlBase}/api/inventory/entry',
        <String, dynamic>{
          'product': productNotifier.value?.id,
          'quantity': quantity,
          'concept': concept,
          'store': AppConstants.branchIdDailyStop
        },
      );

      if (response.statusCode == 200) {
        clear();

        showMessageDialog(context, 'Data successfully recorded');
      } else {
        showMessageDialog(context, 'Error!!');
      }
    } else {
      showMessageDialog(context, 'Error!!');
    }
  }

  void addProduct(context, Product? p) {
    if (p != null) {
      productNotifier.value = p;
    } else {
      showMessageDialog(context, 'Product does not exist');
    }
  }
}
