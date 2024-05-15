import 'package:flutter/material.dart';

import '../models/product_data.dart';

class CountInventoryCard extends StatelessWidget {
  final ProductData productData;
  const CountInventoryCard({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {},
          ),
          title: Text(productData.name),
          trailing: SizedBox(
            width: 50.0,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
              onChanged: (String value) {
                productData.stock = int.parse("0$value");
              },
            ),
          ),
        ),
      ),
    );
  }
}
