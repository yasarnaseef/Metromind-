import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';


class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      throw Exception('Add order failed: $e');
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).update(order.toMap());
    } catch (e) {
      throw Exception('Update order failed: $e');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _firestore.collection('orders').doc(id).delete();
    } catch (e) {
      throw Exception('Delete order failed: $e');
    }
  }

  Stream<List<OrderModel>> getOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => OrderModel.fromMap(doc.id, doc.data())).toList());
  }
}