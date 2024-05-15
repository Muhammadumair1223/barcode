import 'package:flutter/material.dart';

import '../models/product.dart';

class CheckPriceCard extends StatelessWidget {
  final Product product;
  final void Function(Product) onProductSelected;
  const CheckPriceCard(
      {super.key, required this.product, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Cost: \$${product.cost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    onProductSelected(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
