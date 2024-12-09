import 'package:uas_mobile_flutter/models/product_model.dart';

class Transaction {
  List<Product> products;
  DateTime date;
  double totalAmount;

  Transaction({
    required this.products, 
    required this.date, 
    required this.totalAmount
  });

  // Konstruktor dari JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      products: (json['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      date: DateTime.parse(json['date']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }
}