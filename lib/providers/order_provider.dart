import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/order_service.dart';
import 'product_provider.dart';


class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];

  final formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final customerContactController = TextEditingController();
  final productQuantity = TextEditingController();
  DateTime deliveryDate = DateTime.now();
  List<OrderItem> items = [];
  String status = 'Pending';
  String paymentStatus = 'Pending';
  bool isSaving = false;
  clearControllers(){
    customerNameController.clear();
    customerContactController.clear();
    productQuantity.clear();
     status = 'Pending';
     paymentStatus = 'Pending';
     isSaving = false;
     notifyListeners();

  }

  void addItem(String productId, String productName,double productPrice) {
    items.add(OrderItem(productId: productId, quantity: int.tryParse(productQuantity.text)??0, productName: productName, price: productPrice));
    notifyListeners();
  }

  Future<void> selectProductAndQuantity(BuildContext context) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Select Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: productProvider.getProductsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: product.imageUrl.isNotEmpty
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(product.imageUrl),
                            )
                                : const Icon(Icons.image_not_supported),
                            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
                            onTap: () => Navigator.pop(context, product),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
    if (selectedProduct == null) return;

    final quantityText = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quantity for ${selectedProduct.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: productQuantity,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, '1'), // Default
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final quantity = int.tryParse(quantityText ?? '1');
    if (quantity != null && quantity > 0) {
      addItem(selectedProduct.id, selectedProduct.name,selectedProduct.price);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedProduct.name} added to order'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  List<OrderModel> get orders => _orders;

  Stream<List<OrderModel>> getOrdersStream() {
    return _orderService.getOrders().asBroadcastStream();
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _orderService.addOrder(order);
      _orders.add(order); // Optimistic update
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _orderService.updateOrder(order);
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _orderService.deleteOrder(id);
      _orders.removeWhere((o) => o.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}