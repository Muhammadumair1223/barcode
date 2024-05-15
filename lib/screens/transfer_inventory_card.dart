import 'package:flutter/material.dart';

import '../models/product_data.dart';

class TransferInventoryCard extends StatelessWidget {
  final ProductData productData;
  final void Function(ProductData) onProductSelected;
  const TransferInventoryCard({
    super.key,
    required this.productData,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    productData.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onProductSelected(productData);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
              ),
              onChanged: (value) {
                productData.stock = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
