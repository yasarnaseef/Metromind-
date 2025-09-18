import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';


class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(OrderModel order) async {
    try {
      double totalAmount = order.items.fold(0, (total, item) => total + (item.price * item.quantity));
      if(order.items.isNotEmpty){
        for(var item in order.items){
          await _firestore.collection('products').doc(item.productId).set({'quantity':FieldValue.increment((-item.quantity))},SetOptions(merge: true));
        }
      }
      await _firestore.collection('orders').doc(order.id).set({...order.toMap(),'totalAmount':totalAmount,"createdAt":FieldValue.serverTimestamp()});
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