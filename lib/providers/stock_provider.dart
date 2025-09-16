import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  final StockService _stockService = StockService();
  List<StockPurchase> _stockPurchases = [];

  List<StockPurchase> get stockPurchases => _stockPurchases;

  Stream<List<StockPurchase>> getStockPurchasesStream() {
    return _stockService.getStockPurchases().asBroadcastStream();
  }

  Future<void> addStockPurchase(StockPurchase purchase) async {
    try {
      await _stockService.addStockPurchase(purchase);
      _stockPurchases.add(purchase); // Optimistic update
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStockPurchase(StockPurchase purchase) async {
    try {
      await _stockService.updateStockPurchase(purchase);
      final index = _stockPurchases.indexWhere((s) => s.id == purchase.id);
      if (index != -1) {
        _stockPurchases[index] = purchase;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStockPurchase(String id) async {
    try {
      await _stockService.deleteStockPurchase(id);
      _stockPurchases.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }


  Future<void> addDummyProducts() async {
    final firestore = FirebaseFirestore.instance;
    print("Adding dummy products with real product images...");

    List<Product> dummyProducts = [
      Product(
        id: '1',
        name: 'Apple iPhone 14',
        price: 999.99,
        costPrice: 800.00,
        quantity: 20,
        categories: ['Electronics', 'Mobile'],
        imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop',
        description: 'Latest iPhone 14 with A15 Bionic chip.',
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S23',
        price: 899.99,
        costPrice: 700.00,
        quantity: 15,
        categories: ['Electronics', 'Mobile'],
        imageUrl: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop',
        description: 'Samsung flagship phone with Snapdragon 8 Gen 2.',
      ),
      Product(
        id: '3',
        name: 'Sony WH-1000XM5',
        price: 349.99,
        costPrice: 250.00,
        quantity: 30,
        categories: ['Electronics', 'Headphones'],
        imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400&h=400&fit=crop',
        description: 'Noise-canceling wireless headphones.',
      ),
      Product(
        id: '4',
        name: 'Nike Air Max',
        price: 149.99,
        costPrice: 100.00,
        quantity: 50,
        categories: ['Fashion', 'Shoes'],
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
        description: 'Comfortable and stylish running shoes.',
      ),
      Product(
        id: '5',
        name: 'Adidas Ultraboost',
        price: 179.99,
        costPrice: 120.00,
        quantity: 40,
        categories: ['Fashion', 'Shoes'],
        imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400&h=400&fit=crop',
        description: 'High-performance running sneakers.',
      ),
      Product(
        id: '6',
        name: 'Levi\'s 501 Jeans',
        price: 89.99,
        costPrice: 50.00,
        quantity: 60,
        categories: ['Fashion', 'Clothing'],
        imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=400&fit=crop',
        description: 'Classic straight-fit denim jeans.',
      ),
      Product(
        id: '7',
        name: 'Apple MacBook Air M2',
        price: 1199.99,
        costPrice: 950.00,
        quantity: 10,
        categories: ['Electronics', 'Laptop'],
        imageUrl: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=400&fit=crop',
        description: 'Lightweight laptop with Apple M2 chip.',
      ),
      Product(
        id: '8',
        name: 'Dell XPS 13',
        price: 1099.99,
        costPrice: 880.00,
        quantity: 12,
        categories: ['Electronics', 'Laptop'],
        imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop',
        description: 'Premium Windows ultrabook with sleek design.',
      ),
      Product(
        id: '9',
        name: 'Canon EOS R10',
        price: 979.99,
        costPrice: 750.00,
        quantity: 8,
        categories: ['Electronics', 'Camera'],
        imageUrl: 'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=400&h=400&fit=crop',
        description: 'Mirrorless camera with 24.2 MP sensor.',
      ),
      Product(
        id: '10',
        name: 'Instant Pot Duo',
        price: 99.99,
        costPrice: 70.00,
        quantity: 25,
        categories: ['Home Appliances', 'Kitchen'],
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=400&fit=crop',
        description: '7-in-1 electric pressure cooker.',
      ),
    ];

    for (var product in dummyProducts) {
      await firestore.collection('products').doc(product.id).set(product.toMap());
    }

    print("✅ Dummy products with real images added to Firestore!");
  }

  List<OrderModel> getDummyOrders() {
    return [
      OrderModel(
        id: 'ORD001',
        customerName: 'John Smith',
        customerContact: '+1-555-0101',
        items: [
          OrderItem(productId: 'PROD001', quantity: 1),
          OrderItem(productId: 'PROD002', quantity: 2),
        ],
        status: 'Delivered',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 1, 15),
      ),

      OrderModel(
        id: 'ORD002',
        customerName: 'Sarah Johnson',
        customerContact: '+1-555-0102',
        items: [
          OrderItem(productId: 'PROD003', quantity: 1),
          OrderItem(productId: 'PROD004', quantity: 1),
          OrderItem(productId: 'PROD005', quantity: 2),
        ],
        status: 'Processing',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 2, 20),
      ),

      OrderModel(
        id: 'ORD003',
        customerName: 'Mike Davis',
        customerContact: '+1-555-0103',
        items: [
          OrderItem(productId: 'PROD006', quantity: 1),
        ],
        status: 'Shipped',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 1, 28),
      ),

      OrderModel(
        id: 'ORD004',
        customerName: 'Emily Wilson',
        customerContact: '+1-555-0104',
        items: [
          OrderItem(productId: 'PROD007', quantity: 1),
          OrderItem(productId: 'PROD008', quantity: 1),
          OrderItem(productId: 'PROD009', quantity: 1),
        ],
        status: 'Pending',
        paymentStatus: 'Pending',
        deliveryDate: DateTime(2024, 3, 5),
      ),

      OrderModel(
        id: 'ORD005',
        customerName: 'Robert Brown',
        customerContact: '+1-555-0105',
        items: [
          OrderItem(productId: 'PROD010', quantity: 1),
          OrderItem(productId: 'PROD011', quantity: 1),
        ],
        status: 'Delivered',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 1, 10),
      ),

      OrderModel(
        id: 'ORD006',
        customerName: 'Lisa Anderson',
        customerContact: '+1-555-0106',
        items: [
          OrderItem(productId: 'PROD012', quantity: 1),
          OrderItem(productId: 'PROD013', quantity: 3),
          OrderItem(productId: 'PROD014', quantity: 4),
        ],
        status: 'Processing',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 2, 14),
      ),

      OrderModel(
        id: 'ORD007',
        customerName: 'David Taylor',
        customerContact: '+1-555-0107',
        items: [
          OrderItem(productId: 'PROD015', quantity: 2),
          OrderItem(productId: 'PROD016', quantity: 2),
        ],
        status: 'Cancelled',
        paymentStatus: 'Refunded',
        deliveryDate: DateTime(2024, 2, 25),
      ),

      OrderModel(
        id: 'ORD008',
        customerName: 'Jennifer Martinez',
        customerContact: '+1-555-0108',
        items: [
          OrderItem(productId: 'PROD017', quantity: 1),
          OrderItem(productId: 'PROD018', quantity: 1),
        ],
        status: 'Shipped',
        paymentStatus: 'Paid',
        deliveryDate: DateTime(2024, 3, 1),
      ),
    ];

  }

  addCustomer() async {
    for (var product in getDummyOrders()) {
      await FirebaseFirestore.instance.collection('orders').doc(product.id).set(product.toMap());
    }

  }

}