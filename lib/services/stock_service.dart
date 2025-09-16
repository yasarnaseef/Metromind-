import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stock_model.dart';


class StockService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStockPurchase(StockPurchase purchase) async {
    try {
      await _firestore.collection('stock_purchases').doc(purchase.id).set(purchase.toMap());
    } catch (e) {
      throw Exception('Add stock purchase failed: $e');
    }
  }

  Future<void> updateStockPurchase(StockPurchase purchase) async {
    try {
      await _firestore.collection('stock_purchases').doc(purchase.id).update(purchase.toMap());
    } catch (e) {
      throw Exception('Update stock purchase failed: $e');
    }
  }

  Future<void> deleteStockPurchase(String id) async {
    try {
      await _firestore.collection('stock_purchases').doc(id).delete();
    } catch (e) {
      throw Exception('Delete stock purchase failed: $e');
    }
  }

  Stream<List<StockPurchase>> getStockPurchases() {
    return _firestore.collection('stock_purchases').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StockPurchase.fromMap(doc.id, doc.data())).toList());
  }
}