import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../repository/inventory_repository.dart';
import '../utils/app_constants.dart';

abstract class BaseController extends ChangeNotifier {
  final upcController = TextEditingController();
  final searchController = TextEditingController();
  final SharedPreferences sharedPreferences;

  final ValueNotifier<Product?> productNotifier = ValueNotifier<Product?>(null);

  final InventoryRepository repository;

  bool isLoading = false;

  BaseController(this.repository, this.sharedPreferences);

  Future<Product?> searchProduct(String upc) async {
    isLoading = true;
    notifyListeners();

    if (upc.length > 2 && upc.substring(0, 2) == "20") {
      upc = upc.substring(1, 6);
    }

    final response = await repository.authorizedGet(
      "${AppConstants.urlBase}/api/product/upc/${AppConstants.branchIdDailyStop}/$upc",
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Product.fromJson(data);
    }
    return null;
  }

  Future<String?> getPhone() async {
    return sharedPreferences.getString('phone');
  }

  Future<Product?> scanAndSearchProduct() async {
    final result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      var code = result.rawContent;
      upcController.text = code;
      return searchProduct(code);
    }
    return null;
  }

  Future<List<Product>> fetchProducts(String query) async {
    final response = await repository.authorizedGet(
        '${AppConstants.urlBase}/api/product/autocomplete?name=$query');
    if (response.statusCode == 200) {
      final parsed =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      return parsed.map<Product>((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> showMessageDialog(context, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inventory Info'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showAutoCompleteDialog(
      context, void Function(Product) onProductSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search product'),
          content: Autocomplete<Product>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              try {
                final suggestions = await fetchProducts(textEditingValue.text);

                return suggestions;
              } catch (error) {
                return [];
              }
            },
            onSelected: (Product product) {
              onProductSelected(product);
              searchController.clear();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clear() {
    upcController.clear();
    searchController.clear();
    productNotifier.value = null;
  }
}
