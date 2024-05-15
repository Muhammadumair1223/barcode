import '../models/product.dart';
import 'base_controller.dart';

class ShowInventoryController extends BaseController {
  ShowInventoryController(super.repository, super.sharedPreferences);

  void addProduct(context, Product? p) {
    if (p != null) {
      productNotifier.value = p;
    } else {
      showMessageDialog(context, 'Product does not exist');
    }
  }
}
