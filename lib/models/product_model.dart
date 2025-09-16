class Product {
  String id;
  String name;
  double price;
  double costPrice;
  int quantity;
  List<String> categories;
  String imageUrl;
  String description;

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'costPrice': costPrice,
      'quantity': quantity,
      'categories': categories,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
      categories: List<String>.from(map['categories'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }
}