import '../models/product.dart';
import 'base_controller.dart';

class CheckPriceController extends BaseController {
  List<Product> products = [];

  CheckPriceController(super.repository, super.sharedPreferences);

  addProduct(context, Product? p) {
    if (p != null) {
      bool isAlreadyAdded = products.any((product) => product.id == p.id);

      if (!isAlreadyAdded) {
        products.add(p);
        notifyListeners();

        upcController.clear();
      }
    } else {
      showMessageDialog(context, 'Product does not exist');
    }
  }

  deleteProduct(Product p) {
    products.remove(p);
    notifyListeners();
  }
}
