class Product {
  final int id;
  final String name;
  final double price;
  final int? stock;
  final double cost;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.cost,
  });

  @override
  String toString() {
    return name;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      cost: json['cost']?.toDouble() ?? 0,
    );
  }
}
