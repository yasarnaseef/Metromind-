class OrderItem {
  String productId;
  String productName;
  double price;
  int quantity;

  OrderItem({required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['productId'] ?? '',
    productName: map['productName'] ?? '',
    price: map['price'] ?? 0.0,
    quantity: map['quantity'] ?? 0,
  );
}

class OrderModel {
  String id;
  String customerName;
  String customerContact;
  List<OrderItem> items;
  String status;
  String paymentStatus;
  DateTime deliveryDate;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerContact,
    required this.items,
    required this.status,
    required this.paymentStatus,
    required this.deliveryDate,
  });

  Map<String, dynamic> toMap() => {
    'customerName': customerName,
    'customerContact': customerContact,
    'items': items.map((item) => item.toMap()).toList(),
    'status': status,
    'paymentStatus': paymentStatus,
    'deliveryDate': deliveryDate.toIso8601String(),
  };

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) => OrderModel(
    id: id,
    customerName: map['customerName'] ?? '',
    customerContact: map['customerContact'] ?? '',
    items: (map['items'] as List<dynamic>?)
        ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
        .toList() ?? [],
    status: map['status'] ?? 'Pending',
    paymentStatus: map['paymentStatus'] ?? 'Pending',
    deliveryDate: DateTime.parse(map['deliveryDate'] ?? DateTime.now().toIso8601String()),
  );
}