import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _status;
  late String _paymentStatus;

  @override
  void initState() {
    super.initState();
    _status = widget.order.status;
    _paymentStatus = widget.order.paymentStatus;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order.customerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${widget.order.customerName}'),
            Text('Contact: ${widget.order.customerContact}'),
            Text('Delivery Date: ${widget.order.deliveryDate.toString().split(' ')[0]}'),
            DropdownButtonFormField<String>(
              value: _status,
              items: ['Pending', 'Delivered', 'Cancelled'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) async {
                setState(() => _status = value!);
                final updatedOrder = widget.order.copyWith(status: value);
                await Provider.of<OrderProvider>(context, listen: false).updateOrder(updatedOrder);
              },
              decoration: const InputDecoration(labelText: 'Order Status'),
            ),
            DropdownButtonFormField<String>(
              value: _paymentStatus,
              items: ['Pending', 'Paid'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) async {
                setState(() => _paymentStatus = value!);
                final updatedOrder = widget.order.copyWith(paymentStatus: value);
                await Provider.of<OrderProvider>(context, listen: false).updateOrder(updatedOrder);
              },
              decoration: const InputDecoration(labelText: 'Payment Status'),
            ),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  final product = productProvider.products.firstWhere((p) => p.id == item.productId, orElse: () => Product(id: '', name: 'Unknown', price: 0, costPrice: 0, quantity: 0, categories: [], imageUrl: '', description: ''));
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Quantity: ${item.quantity} | Price: ₹${product.price * item.quantity}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension OrderExtension on OrderModel {
  OrderModel copyWith({String? status, String? paymentStatus}) {
    return OrderModel(
      id: id,
      customerName: customerName,
      customerContact: customerContact,
      items: items,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryDate: deliveryDate,
    );
  }
}