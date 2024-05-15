import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/transfer_inventory_controller.dart';
import '../models/product.dart';
import '../models/warehouse_model.dart';
import '../widgets/custom_drawer.dart';
import 'transfer_inventory_card.dart';

class TransferInventoryScreen extends StatelessWidget {
  const TransferInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TransferInventoryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Inventory'),
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
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: controller.selectedFromWarehouse,
              items: controller.warehouses.map((WarehouseModel warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse.name),
                );
              }).toList(),
              hint: const Text('From Wharehouse'),
              onChanged: (WarehouseModel? value) {
                controller.selectedFromWarehouse = value;
              },
            ),
            const SizedBox(height: 6.0),
            DropdownButtonFormField(
              decoration: const InputDecoration(),
              value: controller.selectedToWarehouse,
              items: controller.warehouses.map((WarehouseModel warehouse) {
                return DropdownMenuItem(
                  value: warehouse,
                  child: Text(warehouse.name),
                );
              }).toList(),
              hint: const Text('To Warehouse'),
              onChanged: (WarehouseModel? value) {
                controller.selectedToWarehouse = value;
              },
            ),
            const SizedBox(height: 6.0),
            TextFormField(
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
            Expanded(
              child: ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return TransferInventoryCard(
                    productData: controller.products[index],
                    onProductSelected: (p) {
                      controller.deleteProduct(p);
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
