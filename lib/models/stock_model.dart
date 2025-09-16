
class StockPurchaseItem {
  String productId;
  int quantity;
  double cost;

  StockPurchaseItem({required this.productId, required this.quantity, required this.cost});
}

class StockPurchase {
  String id;
  String supplierName;
  DateTime purchaseDate;
  List<StockPurchaseItem> items;
  double totalCost;
  String notes;

  StockPurchase({
    required this.id,
    required this.supplierName,
    required this.purchaseDate,
    required this.items,
    required this.totalCost,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'supplierName': supplierName,
      'purchaseDate': purchaseDate.toIso8601String(),
      'items': items.map((item) => {'productId': item.productId, 'quantity': item.quantity, 'cost': item.cost}).toList(),
      'totalCost': totalCost,
      'notes': notes,
    };
  }

  factory StockPurchase.fromMap(String id, Map<String, dynamic> map) {
    return StockPurchase(
      id: id,
      supplierName: map['supplierName'] ?? '',
      purchaseDate: DateTime.parse(map['purchaseDate']),
      items: (map['items'] as List).map((item) => StockPurchaseItem(
        productId: item['productId'],
        quantity: item['quantity'],
        cost: item['cost']?.toDouble() ?? 0.0,
      )).toList(),
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
      notes: map['notes'] ?? '',
    );
  }
}