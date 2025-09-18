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
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  double todaySalesAmount=0;

  fetchTodaySales() async {
    todaySalesAmount=0;
    DateTime day = DateTime.now();
    DateTime startDate = DateTime(day.year, day.month, day.day);
    DateTime endDate = startDate.add(const Duration(hours: 23, seconds: 59, minutes: 59));
    final query=await db.collection("orders")
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThanOrEqualTo: endDate).aggregate(sum('totalAmount')).get();
    todaySalesAmount=query.getSum('totalAmount') ?? 0;
    notifyListeners();
  }

double monthlySalesAmount=0;
  int monthlyOrdersCount =0;

  final List<Map<String, dynamic>> lowStockProductsList = [];
  List<Map<String, dynamic>> topSellingProducts = [];

  Future<void> loadDashboardData() async {
    if (_isLoading) return;

    topSellingProducts.clear();
    lowStockProductsList.clear();
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();

      // First and last day of current month
      final startDate = DateTime(now.year, now.month, 1);
      final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      monthlySalesAmount = 0;
      monthlyOrdersCount = 0;

      // Run queries in parallel
      fetchTodaySales(); // not awaited on purpose
      final futures = await Future.wait([
        db.collection("orders")
            .where('createdAt', isGreaterThanOrEqualTo: startDate)
            .where('createdAt', isLessThanOrEqualTo: endDate)
            .get(),
        db.collection('products')
            .where('quantity', isLessThan: 5)
            .get(),
      ]);

      // Orders query
      final ordersQuery = futures[0] as QuerySnapshot;
      if (ordersQuery.docs.isNotEmpty) {
        monthlyOrdersCount = ordersQuery.docs.length;

        // Sum sales
        monthlySalesAmount = ordersQuery.docs.fold<double>(0.0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          final amount = (data['totalAmount'] ?? 0).toDouble();
          return sum + amount;
        });

        // 🔥 Compute top-selling products
        final Map<String, int> productSales = {};

        for (final doc in ordersQuery.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final List<dynamic> items = data['items'] ?? [];

          for (final item in items) {
            final productId = item['productId'];
            final quantity = (item['quantity'] ?? 0) as int;

            if (productId != null) {
              productSales[productId] = (productSales[productId] ?? 0) + quantity;
            }
          }
        }

        // Sort by quantity sold (descending)
        final sortedProducts = productSales.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // 🔎 Fetch product details for top 5
        for (final entry in sortedProducts.take(5)) {
          final productDoc = await db.collection('products').doc(entry.key).get();
          final productData = productDoc.data() as Map<String, dynamic>?;

          topSellingProducts.add({
            'productId': entry.key,
            'name': productData?['name'] ?? 'Unknown',
            'quantity': entry.value,
          });
        }
      }

      // Low stock products
      final productsSnapshot = futures[1] as QuerySnapshot;
      final firestoreProducts = productsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      lowStockProductsList.addAll(firestoreProducts);

      notifyListeners();
    } catch (e) {
      debugPrint('Dashboard load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



}