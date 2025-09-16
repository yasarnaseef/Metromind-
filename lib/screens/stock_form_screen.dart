import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../providers/product_provider.dart';
import '../providers/stock_provider.dart';


class StockFormScreen extends StatefulWidget {
  const StockFormScreen({Key? key}) : super(key: key);

  @override
  State<StockFormScreen> createState() => _StockFormScreenState();
}

class _StockFormScreenState extends State<StockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _purchaseDate = DateTime.now();
  List<StockPurchaseItem> _items = [];
  double _totalCost = 0.0;

  @override
  void dispose() {
    _supplierNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem(String productId, int quantity, double cost) {
    setState(() {
      _items.add(StockPurchaseItem(productId: productId, quantity: quantity, cost: cost));
      _totalCost += quantity * cost;
    });
  }

  Future<void> _selectProductQuantityCost() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Product'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: StreamBuilder<List<Product>>(
            stream: productProvider.getProductsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Current Qty: ${product.quantity}'),
                    onTap: () => Navigator.pop(context, product),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
    if (selectedProduct == null) return;

    final quantityText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quantity for ${selectedProduct.name}'),
        content: TextField(
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Quantity'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, '1'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    final quantity = int.tryParse(quantityText ?? '1');
    if (quantity == null || quantity <= 0) return;

    final costText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cost per Unit'),
        content: TextField(
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Cost (₹)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, '0'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    final cost = double.tryParse(costText ?? '0');
    if (cost != null && cost > 0) {
      _addItem(selectedProduct.id, quantity, cost);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${selectedProduct.name} added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Stock Purchase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _supplierNameController,
                  decoration: const InputDecoration(labelText: 'Supplier Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                ListTile(
                  title: const Text('Purchase Date'),
                  subtitle: Text(_purchaseDate.toString().split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _purchaseDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _purchaseDate = date);
                  },
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectProductQuantityCost,
                  child: const Text('Add Product to Purchase'),
                ),
                if (_items.isEmpty)
                  const Text('No items added yet')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final productProvider = Provider.of<ProductProvider>(context);
                      final product = productProvider.products.firstWhere((p) => p.id == item.productId, orElse: () => Product(id: '', name: 'Unknown', price: 0, costPrice: 0, quantity: 0, categories: [], imageUrl: '', description: ''));
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Quantity: ${item.quantity} | Cost/Unit: ₹${item.cost.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _totalCost -= item.quantity * item.cost;
                              _items.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total Cost: ₹${_totalCost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: _items.isEmpty
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
                      try {
                        final purchase = StockPurchase(
                          id: const Uuid().v4(),
                          supplierName: _supplierNameController.text,
                          purchaseDate: _purchaseDate,
                          items: _items,
                          totalCost: _totalCost,
                          notes: _notesController.text,
                        );
                        await Provider.of<StockProvider>(context, listen: false).addStockPurchase(purchase);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock purchase saved')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  child: const Text('Save Purchase'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}