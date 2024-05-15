class ProductResponse {
  final String upc;
  final double price;
  final String name;
  final double tax;
  final String message;

  ProductResponse(
      {required this.upc,
      required this.price,
      required this.name,
      required this.tax,
      required this.message});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      upc: json['upc'],
      price: double.parse(json['price'].toString()),
      name: json['name'],
      tax: double.parse(json['tax'].toString()),
      message: json['message'],
    );
  }
}
