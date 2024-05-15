import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inventory_entry_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';

class EntryInventory extends StatelessWidget {
  const EntryInventory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InventoryEntryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Inventory'),
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
            const SizedBox(height: 6),
            ValueListenableBuilder<Product?>(
              valueListenable: controller.productNotifier,
              builder: (context, product, child) {
                return Center(
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
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: controller.selectedConcept,
              items: controller.conceptOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controller.selectedConcept = newValue;
              },
              decoration: const InputDecoration(
                labelText: 'Concept',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
