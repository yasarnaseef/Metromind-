import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';


class DashboardProvider with ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Product> lowStockProducts = [];
  double todaysSales = 0.0;
  double monthlySales = 0.0;
  int monthlyOrders = 0;
  List<Map<String, dynamic>> topSellingProducts = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadDashboardData() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final monthStart = DateTime(now.year, now.month, 1);

      // Low Stock
      final productsSnapshot = await db
          .collection('products')
          .where('quantity', isLessThan: 5)
          .get();
      lowStockProducts = productsSnapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();

      // Today's Sales
      final todayOrdersSnapshot = await db
          .collection('orders')
          .where('deliveryDate', isGreaterThanOrEqualTo: today.toIso8601String())
          .where('deliveryDate', isLessThan: tomorrow.toIso8601String())
          .where('status', isEqualTo: 'Delivered')
          .get();
      final todayOrders = todayOrdersSnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id,doc.data()))
          .toList();
      todaysSales = await _calculateOrderTotal(todayOrders);

      // Monthly Overview
      final monthlyOrdersSnapshot = await db
          .collection('orders')
          .where('deliveryDate',
          isGreaterThanOrEqualTo: monthStart.toIso8601String())
          .get();
      final monthlyOrdersList = monthlyOrdersSnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id,doc.data()))
          .toList();
      monthlySales = await _calculateOrderTotal(monthlyOrdersList);
      monthlyOrders = monthlyOrdersList.length; // Fixed: Use length for count

      // Top Selling Products
      final productSales = <String, int>{};
      for (var order in monthlyOrdersList) {
      for (var item in order.items) {
          productSales[item.productId] =
              ((productSales[item.productId] ?? 0) + item.quantity).toInt();

      }
      }
      topSellingProducts = [];
      for (var entry in productSales.entries) {
        final productDoc = await db
            .collection('products')
            .doc(entry.key)
            .get();
        if (productDoc.exists) {
          final product = Product.fromMap(entry.key, productDoc.data()!);
          topSellingProducts.add({'product': product, 'quantity': entry.value});
        }
      }
      topSellingProducts.sort((a, b) => b['quantity'].compareTo(a['quantity']));
      topSellingProducts = topSellingProducts.take(5).toList();
    } catch (e) {
      debugPrint('Dashboard load error: $e');
      // Optionally, notify UI of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> _calculateOrderTotal(List<OrderModel> orders) async {
    double total = 0.0;
    for (var order in orders) {
    for (var item in order.items) {

        final productDoc = await db
            .collection('products')
            .doc(item.productId)
            .get();
        if (productDoc.exists) {
          final product = Product.fromMap(productDoc.id, productDoc.data()!);
          total += product.price * item.quantity;
      }
    }
    }
    return total;
  }
}