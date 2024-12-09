class Product {
  String name;
  double price;

  Product({required this.name, required this.price});

  // Konstruktor dari JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
