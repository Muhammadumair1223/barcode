import 'dart:convert';

import '../models/product.dart';
import '../models/product_data.dart';
import '../models/warehouse_model.dart';
import '../utils/app_constants.dart';
import 'base_controller.dart';

class TransferInventoryController extends BaseController {
  WarehouseModel? selectedFromWarehouse;
  WarehouseModel? selectedToWarehouse;

  List<WarehouseModel> warehouses = [];
  List<ProductData> products = [];

  TransferInventoryController(super.repository, super.sharedPreferences) {
    loadData();
  }

  void loadData() async {
    warehouses = await loadWarehouses();
    notifyListeners();
  }

  Future<List<WarehouseModel>> loadWarehouses() async {
    var response = await repository.authorizedGet(
      "${AppConstants.urlBase}/api/warehouse/all/branch/${AppConstants.branchIdDailyStop}",
    );
    if (response.statusCode == 200) {
      final parsed =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      return parsed
          .map<WarehouseModel>((json) => WarehouseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  addProduct(context, Product? product) {
    if (product != null) {
      var productData = ProductData(
        id: product.id,
        name: product.name,
        stock: product.stock ?? 0,
      );

      bool isAlreadyAdded = products.any((p) => p.id == productData.id);

      if (!isAlreadyAdded) {
        products.add(productData);
        notifyListeners();
      }
    } else {
      showMessageDialog(context, 'Product does not exist');
    }
  }

  deleteProduct(ProductData p) {
    products.remove(p);
    notifyListeners();
  }

  Future<void> submitData(context) async {
    if (products.isNotEmpty &&
        selectedFromWarehouse != null &&
        selectedToWarehouse != null) {
      var response = await repository.authorizedPost(
        '${AppConstants.urlBase}/api/inventorytransfer',
        <String, dynamic>{
          'fromWarehouseId': selectedFromWarehouse?.id,
          'ToWarehouseId': selectedToWarehouse?.id,
          'BranchId': AppConstants.branchIdDailyStop,
          'PhoneNumber': await getPhone(),
          'Items': products
              .map((prod) => {
                    'ProductId': prod.id,
                    'Cost': 0.0,
                    'Quantity': prod.stock,
                  })
              .toList()
        },
      );

      if (response.statusCode == 200) {
        showMessageDialog(context, 'The transfer was successfully registered.');

        products.clear();
        notifyListeners();
      } else {
        showMessageDialog(
            context, 'The inventory transfer could not be recorded.');
      }
    } else {
      showMessageDialog(context, "Error!!");
    }
  }
}
