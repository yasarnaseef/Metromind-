import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double costPrice;
  final int quantity;
  final List<String> categories;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.costPrice,
    required this.quantity,
    required this.categories,
    required this.imageUrl,
    required this.description,
  });

  /// Convert Product -> Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': id, // keep product id inside doc as well (helps in queries)
      'name': name,
      'price': price,
      'costPrice': costPrice,
      'quantity': quantity,
      'categories': categories,
      'imageUrl': imageUrl,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(), // optional
    };
  }

  /// Convert Firestore Map -> Product
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      costPrice: (map['costPrice'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      categories: List<String>.from(map['categories'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  /// Copy product with new values
  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? costPrice,
    int? quantity,
    List<String>? categories,
    String? imageUrl,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
