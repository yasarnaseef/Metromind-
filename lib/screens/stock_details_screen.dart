import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../providers/product_provider.dart';
import '../providers/stock_provider.dart';

class StockDetailScreen extends StatelessWidget {
  final StockPurchase purchase;
  const StockDetailScreen({Key? key, required this.purchase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(purchase.supplierName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<StockProvider>(context, listen: false).deleteStockPurchase(purchase.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock purchase deleted')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supplier: ${purchase.supplierName}'),
            Text('Purchase Date: ${purchase.purchaseDate.toString().split(' ')[0]}'),
            Text('Total Cost: ₹${purchase.totalCost.toStringAsFixed(2)}'),
            if (purchase.notes.isNotEmpty) Text('Notes: ${purchase.notes}'),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: purchase.items.length,
                itemBuilder: (context, index) {
                  final item = purchase.items[index];
                  final product = productProvider.products.firstWhere((p) => p.id == item.productId, orElse: () => Product(id: '', name: 'Unknown', price: 0, costPrice: 0, quantity: 0, categories: [], imageUrl: '', description: ''));
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Quantity: ${item.quantity} | Cost per Unit: ₹${item.cost.toStringAsFixed(2)} | Total: ₹${(item.quantity * item.cost).toStringAsFixed(2)}'),
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
