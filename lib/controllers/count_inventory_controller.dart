import '../models/product.dart';
import '../models/product_data.dart';
import '../utils/app_constants.dart';
import 'base_controller.dart';

class CountInventoryController extends BaseController {
  List<ProductData> countData = [];

  CountInventoryController(super.repository, super.sharedPreferences);

  addProduct(Product product) {
    countData.add(ProductData(
      id: product.id,
      name: product.name,
      stock: product.stock ?? 0,
    ));
    notifyListeners();
  }

  Future<void> submitData(context) async {
    if (countData.isNotEmpty) {
      var response = await repository.authorizedPost(
        '${AppConstants.urlBase}/api/countinventory',
        <String, dynamic>{
          'BranchId': AppConstants.branchIdDailyStop,
          'PhoneNumber': '',
          'Items': countData
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

        countData.clear();
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
