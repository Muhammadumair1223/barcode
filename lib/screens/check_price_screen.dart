import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/check_price_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';
import 'check_price_card.dart';

class CheckPriceScreen extends StatelessWidget {
  const CheckPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CheckPriceController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Price'),
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
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: true,
              onFieldSubmitted: (value) async {
                Product? product = await controller.searchProduct(value);
                // ignore: use_build_context_synchronously
                controller.addProduct(context, product);
              },
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.number,
              controller: controller.upcController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Scan Product",
                hintStyle: Theme.of(context).textTheme.labelLarge,
                labelText: 'Enter or Scan Product Code',
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
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            if (controller.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckPriceCard(
                    product: controller.products[index],
                    onProductSelected: (Product product) {
                      controller.deleteProduct(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
