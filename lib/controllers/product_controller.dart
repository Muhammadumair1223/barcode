import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_response.dart';
import '../utils/app_constants.dart';
import 'base_controller.dart';

class ProductController extends BaseController {
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final nameController = TextEditingController();

  ProductController(super.repository, super.sharedPreferences);

  bool isEBTChecked = false;
  bool isTaxChecked = false;

  void changeEBT() {
    isEBTChecked = !isEBTChecked;
    notifyListeners();
  }

  void changeTAX() {
    isTaxChecked = !isTaxChecked;
    notifyListeners();
  }

  Future<void> submitData(context) async {
    double price = double.parse("0${priceController.text}");
    double cost = double.parse("0${costController.text}");
    String name = nameController.text;
    String barcodeResult = upcController.text;

    if (barcodeResult.isNotEmpty && price > 0) {
      var response = await repository.authorizedPost(
          '${AppConstants.urlBase}/api/product/update', <String, dynamic>{
        'name': name,
        'price': price,
        'upc': barcodeResult,
        'tax': isTaxChecked ? 7.0 : 0.0,
        'ebt': isEBTChecked,
        'cost': cost,
      });

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        ProductResponse? productResponse = ProductResponse.fromJson(data);

        isTaxChecked = false;
        isEBTChecked = false;
        upcController.text = "";
        priceController.text = "";
        costController.text = "";
        nameController.text = "";

        notifyListeners();

        showMessageDialog(context, productResponse.message);
      }
    } else {
      showMessageDialog(context, "Please enter data");
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
