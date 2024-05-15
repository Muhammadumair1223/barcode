import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/show_inventory_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';

class ShowInventoryScreen extends StatelessWidget {
  const ShowInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ShowInventoryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Inventory'),
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
        child: ListView(
          children: [
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
            ValueListenableBuilder<Product?>(
              valueListenable: controller.productNotifier,
              builder: (context, product, child) {
                return Column(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            product == null
                                ? "Enter a barcode to search"
                                : product.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.orange,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          product == null
                              ? "Stock: 0"
                              : "Stock: ${product.stock.toString()}",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
