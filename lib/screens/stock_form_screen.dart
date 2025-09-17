import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../providers/product_provider.dart';
import '../providers/stock_provider.dart';


class StockFormScreen extends StatelessWidget {
  const StockFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ThemeData for consistent styling
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Purchase'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Consumer<StockProvider>(
        builder: (context, stockPro, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: stockPro.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Supplier Name Field
                    TextFormField(
                      controller: stockPro.supplierNameController,
                      decoration: InputDecoration(
                        labelText: 'Supplier Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Supplier name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Purchase Date Picker
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'Purchase Date',
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          stockPro.purchaseDate.toString().split(' ')[0],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: stockPro.purchaseDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: theme.copyWith(
                                  datePickerTheme: DatePickerThemeData(
                                    backgroundColor: theme.colorScheme.surface,
                                    headerBackgroundColor: theme.colorScheme.primary,
                                    headerForegroundColor: theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            stockPro.updateDate(date);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes Field
                    TextFormField(
                      controller: stockPro.notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Add Product Button
                    FilledButton(
                      onPressed: () {
                        stockPro.selectProductQuantityCost(context);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Product to Purchase'),
                    ),
                    const SizedBox(height: 16),

                    // Product List
                    stockPro.items.isEmpty
                        ? Center(
                      child: Text(
                        'No items added yet',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stockPro.items.length,
                      itemBuilder: (context, index) {
                        final item = stockPro.items[index];
                        final productProvider = Provider.of<ProductProvider>(context);
                        final product = productProvider.products.firstWhere(
                              (p) => p.id == item.productId,
                          orElse: () => Product(
                            id: '',
                            name: 'Unknown',
                            price: 0,
                            costPrice: 0,
                            quantity: 0,
                            categories: [],
                            imageUrl: '',
                            description: '',
                          ),
                        );
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              product.name,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              'Quantity: ${item.quantity} | Cost/Unit: ₹${item.cost.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () {
                                stockPro.removeProduct(index, item);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Total Cost
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost:',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${stockPro.totalCost.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Purchase Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: stockPro.items.isEmpty
                            ? null
                            : () async {
                          if (stockPro.formKey.currentState!.validate() &&
                              stockPro.items.isNotEmpty) {
                            try {
                              final purchase = StockPurchase(
                                id: const Uuid().v4(),
                                supplierName: stockPro.supplierNameController.text,
                                purchaseDate: stockPro.purchaseDate,
                                items: stockPro.items,
                                totalCost: stockPro.totalCost,
                                notes: stockPro.notesController.text,
                              );
                              await Provider.of<StockProvider>(context, listen: false)
                                  .addStockPurchase(purchase);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Stock purchase saved'),
                                  backgroundColor: theme.colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: theme.colorScheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
                        ),
                        child: const Text('Save Purchase'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}