import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';


class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];

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