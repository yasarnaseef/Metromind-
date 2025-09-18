import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';



class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Order'),
        elevation: 0,

      ),
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context,orderPro,child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: orderPro.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: orderPro.customerNameController,
                                decoration: InputDecoration(
                                  labelText: 'Customer Name',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                validator: (value) => value!.isEmpty ? 'Customer name is required' : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: orderPro.customerContactController,
                                decoration: InputDecoration(
                                  labelText: 'Contact',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                validator: (value) => value!.isEmpty ? 'Contact is required' : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Details',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Delivery Date', style: TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  orderPro.deliveryDate.toString().split(' ')[0],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                trailing: const Icon(Icons.calendar_today, color: Colors.blue),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: orderPro.deliveryDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) => Theme(
                                      data: theme.copyWith(
                                        colorScheme: theme.colorScheme.copyWith(
                                          primary: theme.primaryColor,
                                          onPrimary: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (date != null) setState(() => orderPro.deliveryDate = date);
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: orderPro.status,
                                items: ['Pending', 'Delivered', 'Cancelled'].map((status) {
                                  return DropdownMenuItem(value: status, child: Text(status));
                                }).toList(),
                                onChanged: (value) => setState(() => orderPro.status = value!),
                                decoration: InputDecoration(
                                  labelText: 'Order Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: orderPro.paymentStatus,
                                items: ['Pending', 'Paid'].map((status) {
                                  return DropdownMenuItem(value: status, child: Text(status));
                                }).toList(),
                                onChanged: (value) => setState(() => orderPro.paymentStatus = value!),
                                decoration: InputDecoration(
                                  labelText: 'Payment Status',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Items',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: (){
                                  orderPro.selectProductAndQuantity(context);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Product'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                              ),
                              const SizedBox(height: 12),
                              orderPro.items.isEmpty
                                  ? const Center(
                                child: Text(
                                  'No items added yet',
                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                ),
                              )
                                  : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderPro.items.length,
                                itemBuilder: (context, index) {
                                  final item = orderPro.items[index];
                                  final productProvider = Provider.of<ProductProvider>(context);
                                  final product = productProvider.products.firstWhere(
                                        (p) => p.id == item.productId,
                                    orElse: () => Product(
                                      id: item.productId,
                                      name: item.productName,
                                      price: item.price,
                                      costPrice: 0,
                                      quantity: item.quantity,
                                      categories: [],
                                      imageUrl: '',
                                      description: '',
                                    ),
                                  );
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        'Quantity: ${item.quantity} | ₹${(product.price * item.quantity).toStringAsFixed(2)}',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => setState(() => orderPro.items.removeAt(index)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: orderPro.items.isEmpty || orderPro.isSaving
                              ? null
                              : () async {
                            if (orderPro.formKey.currentState!.validate() && orderPro.items.isNotEmpty) {
                              setState(() => orderPro.isSaving = true);
                              try {
                                final order = OrderModel(
                                  id: const Uuid().v4(),
                                  customerName: orderPro.customerNameController.text,
                                  customerContact: orderPro.customerContactController.text,
                                  items: orderPro.items,
                                  status: orderPro.status,
                                  paymentStatus: orderPro.paymentStatus,
                                  deliveryDate: orderPro.deliveryDate,
                                );
                                await orderPro.addOrder(order);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order saved successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() => orderPro.isSaving = false);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: orderPro.isSaving
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                              : const Text('Save Order', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}