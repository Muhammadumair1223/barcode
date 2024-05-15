import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/count_inventory_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';
import 'count_inventory_card.dart';

class CountInventoryScreen extends StatelessWidget {
  const CountInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CountInventoryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Count Inventory'),
        actions: [
          IconButton(
            onPressed: () {
              controller.showAutoCompleteDialog(context, (Product product) {
                controller.addProduct(product);
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
        child: Column(
          children: [
            TextFormField(
              onFieldSubmitted: (value) async {
                Product? product = await controller.searchProduct(value);
                if (product != null) {
                  controller.addProduct(product);
                  controller.upcController.clear();
                }
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
                    if (product != null) {
                      controller.addProduct(product);
                      controller.upcController.clear();
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: ListView.builder(
                itemCount: controller.countData.length,
                itemBuilder: (BuildContext context, int index) {
                  return CountInventoryCard(
                      productData: controller.countData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
