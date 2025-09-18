import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';


class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  final db = FirebaseFirestore.instance;
  // final storage = FirebaseStorage.instance;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final costPriceController = TextEditingController();
  final quantityController = TextEditingController();
  final categoriesController = TextEditingController();
  String productImage="";
  XFile? image;
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = pickedFile;
        notifyListeners();
      }
    } catch (e) {

    }
  }

  void removeImage() {
    image = null;
    notifyListeners();
  }

  Future<bool> confirmSave(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Save'),
        content: const Text('Are you sure you want to save this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<void> saveProduct(BuildContext context,Product item,String fromWhere) async {
    if (!formKey.currentState!.validate()) return;

    final confirmed = await confirmSave(context);
    if (!confirmed) return;

    isLoading = true;
    notifyListeners();
    try {
      final product = Product(
        id: item.id ?? const Uuid().v4(),
        name: nameController.text.trim(),
        price: double.parse(priceController.text.trim()),
        costPrice: double.parse(costPriceController.text.trim()),
        quantity: int.parse(quantityController.text.trim()),
        categories: categoriesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        imageUrl: item.imageUrl ?? '',
        description: descriptionController.text.trim(),
      );

      if (fromWhere == 'Add') {
        print("m jdcndhndvnudnv ");
        await addProduct(product, image);
      } else {
        await updateProduct(product, image);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product: $e')),
      );
    } finally {
      isLoading = false;
    }
  }

  List<Product> _products = [];

  List<Product> get products => _products;

  Stream<List<Product>> getProductsStream() {
    return _productService.getProducts().asBroadcastStream();
  }

  Future<void> addProduct(Product product, XFile? image) async {
    try {
      await _productService.addProduct(product, image);
      _products.add(product); // Optimistic update
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }




  setProductDetails(Product product){
    if(product==null)return;
    nameController.text =product!.name;
    descriptionController.text = product!.description;
    priceController.text = product!.price.toStringAsFixed(2);
    costPriceController.text = product!.costPrice.toStringAsFixed(2);
    quantityController.text = product!.quantity.toString();
    categoriesController.text = product!.categories.join(', ');
    productImage=product.imageUrl;
    notifyListeners();
  }
  Future<void> updateProduct(Product product, XFile? image) async {
    try {
      await _productService.updateProduct(product, image);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  void clearProductDetails() {
    isLoading=false;
    image = null;
    productImage="";
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    costPriceController.clear();
    quantityController.clear();
    categoriesController.clear();
    notifyListeners();
  }


}