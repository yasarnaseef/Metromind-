import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatelessWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product == null ? 'Add Product' : 'Edit Product',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (product != null)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Cancel',
            ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context,productPro,child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Form(
                key: productPro.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: productPro.nameController,
                        label: 'Product Name',
                        validator: (value) =>
                        value!.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: productPro.priceController,
                        label: 'Price',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Price is required';
                          if (double.tryParse(value.trim()) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: productPro.costPriceController,
                        label: 'Cost Price (Private)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Cost price is required';
                          if (double.tryParse(value.trim()) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: productPro.quantityController,
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.trim().isEmpty) return 'Quantity is required';
                          if (int.tryParse(value.trim()) == null) {
                            return 'Enter a valid integer';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: productPro.categoriesController,
                        label: 'Categories (comma separated)',
                        hint: 'e.g., Electronics, Gadgets',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: productPro.descriptionController,
                        label: 'Description',
                        maxLines: 3,
                        validator: (value) =>
                        value!.trim().isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildImagePicker(theme),
                      const SizedBox(height: 24),
                      _buildButtonRow(theme,product!),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return Consumer<ProductProvider>(
        builder: (context,productPro,child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: productPro.pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                if (productPro.image != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: productPro.removeImage,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            if (productPro.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(productPro.image!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        );
      }
    );
  }

  Widget _buildButtonRow(ThemeData theme,Product product) {
    return Consumer<ProductProvider>(
        builder: (context,productPro,child) {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: productPro.isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: theme.colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: productPro.isLoading ? null : (){
                  productPro.saveProduct(context,product);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:productPro.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : const Text('Save Product', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
      }
    );
  }
}