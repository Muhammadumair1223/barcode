import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/out_stock_controller.dart';
import '../models/product.dart';
import '../widgets/custom_drawer.dart';

class OutStockScreen extends StatelessWidget {
  const OutStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OutStockController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OUT STOCK'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            if (controller.product != null)
              Text(
                controller.product!.name,
              ),
            TextFormField(
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
                  icon: const Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {},
                  icon: const Icon(Icons.search),
                ),
              ),
              onFieldSubmitted: (_) async {
                Product? product = await controller
                    .searchProduct(controller.upcController.text);
                if (product != null) {
                  controller.addProduct(product);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Quantity",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                hintText: "Concept",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              value: controller.selectedConcept,
              items: controller.conceptOptions.map((String concept) {
                return DropdownMenuItem(
                  value: concept,
                  child: Text(concept),
                );
              }).toList(),
              hint: const Text('Concept'),
              onChanged: (String? value) {
                controller.selectedConcept = value;
              },
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () => controller.submitData(context),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
