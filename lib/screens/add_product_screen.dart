import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            onPressed: () {
              controller.showAutoCompleteDialog(context, (Product product) {
                controller.addProduct(context, product);
                controller.searchController.clear();
              });
            },
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            onPressed: () => controller.submitData(context),
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              onFieldSubmitted: (value) async {
                Product? product = await controller.searchProduct(value);
                // ignore: use_build_context_synchronously
                controller.addProduct(context, product);
                controller.upcController.clear();
              },
              controller: controller.upcController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Scan Product',
                prefixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () => controller.clear(),
                  icon: const Icon(Icons.cleaning_services),
                ),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {
                    Product? product = await controller.scanAndSearchProduct();
                    // ignore: use_build_context_synchronously
                    controller.addProduct(context, product);
                    controller.upcController.clear();
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            if (controller.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: controller.nameController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Name',
                hintText: "Name",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Price',
                hintText: "Price",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: controller.costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                labelText: 'Cost',
                hintText: "Cost",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('EBT'),
                Checkbox(
                  value: controller.isEBTChecked,
                  onChanged: (value) {
                    controller.changeEBT();
                  },
                ),
                const Text('Tax'),
                Checkbox(
                  value: controller.isTaxChecked,
                  onChanged: (value) {
                    controller.changeTAX();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
