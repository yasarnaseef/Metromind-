import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/stock_provider.dart';

class StockPurchaseScreen extends StatelessWidget {
  const StockPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<StockProvider>(
        builder: (context,stockPro,child) {
          return Form(
            key: stockPro.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.blue[600],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'New Stock Purchase',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add purchase details and product information',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Supplier Information Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supplier Information',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Supplier Name
                          TextFormField(
                            controller: stockPro.supplierController,
                            decoration: InputDecoration(
                              labelText: 'Supplier Name *',
                              hintText: 'Enter supplier name',
                              prefixIcon: const Icon(Icons.business),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Supplier name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Purchase Date
                          InkWell(
                            onTap: (){
                              stockPro.selectDate(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[50],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.grey),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      stockPro.selectedDate == null
                                          ? 'Select Purchase Date *'
                                          : '${stockPro.selectedDate!.day}/${stockPro.selectedDate!.month}/${stockPro.selectedDate!.year}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: stockPro.selectedDate == null
                                            ? Colors.grey[600]
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Products Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Products & Quantities',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              // ElevatedButton.icon(
                              //   onPressed: stockPro.addProduct,
                              //   icon: const Icon(Icons.add, size: 18),
                              //   label: const Text('Add Product'),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Colors.blue[50],
                              //     foregroundColor: Colors.blue[700],
                              //     elevation: 0,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          ...List.generate(stockPro.products.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Product ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (stockPro.products.length > 1)
                                          IconButton(
                                            onPressed: () =>stockPro.removeProduct(index),
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red,
                                            ),
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: stockPro.products[index].nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Product Name *',
                                        hintText: 'Enter product name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Product name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: stockPro.products[index].quantityController,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity *',
                                        hintText: 'Enter quantity',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Quantity is required';
                                        }
                                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                          return 'Enter a valid quantity';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Cost and Notes Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Details',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Total Cost
                          TextFormField(
                            controller: stockPro.costController,
                            decoration: InputDecoration(
                              labelText: 'Total Cost *',
                              hintText: 'Enter total cost',
                              prefixIcon: const Icon(Icons.currency_rupee),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total cost is required';
                              }
                              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                return 'Enter a valid cost';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Notes
                          TextFormField(
                            controller: stockPro.notesController,
                            decoration: InputDecoration(
                              labelText: 'Notes (Optional)',
                              hintText: 'Add any additional notes...',
                              prefixIcon: const Icon(Icons.note_add),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            maxLines: 3,
                            maxLength: 500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: stockPro.resetForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.grey[400]!),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: (){
                            stockPro.savePurchase(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Save Purchase',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class ProductItem {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
  }
}