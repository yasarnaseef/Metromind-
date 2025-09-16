import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stock_model.dart';
import '../providers/stock_provider.dart';
import 'stock_details_screen.dart';
import 'stock_form_screen.dart';


class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Purchases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Provider.of<StockProvider>(context,listen: false).addCustomer();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StockFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<StockPurchase>>(
        stream: Provider.of<StockProvider>(context).getStockPurchasesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stock purchases found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final purchase = snapshot.data![index];
              return ListTile(
                title: Text(purchase.supplierName),
                subtitle: Text('Date: ${purchase.purchaseDate.toString().split(' ')[0]} | Total: ₹${purchase.totalCost.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StockDetailScreen(purchase: purchase),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}