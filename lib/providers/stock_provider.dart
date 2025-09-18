import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/stock_model.dart';
import '../screens/stock_form_screen.dart';
import '../services/stock_service.dart';
import 'product_provider.dart';

class StockProvider with ChangeNotifier {

  final formKey = GlobalKey<FormState>();
  final supplierController = TextEditingController();
  final costController = TextEditingController();
  final notesController = TextEditingController();

  DateTime? selectedDate;
  List<ProductItem> products = [ProductItem()];
  void resetForm() {
    formKey.currentState!.reset();
    supplierController.clear();
    costController.clear();
    notesController.clear();
    selectedDate = null;
    products = [ProductItem()];
    notifyListeners();
  }


  void addProduct() {
    products.add(ProductItem());
  }
  void removeProduct(int index) {
    if (products.length > 1) {
      products.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  void savePurchase(BuildContext context) {
    if (formKey.currentState!.validate() && selectedDate != null) {
      // Here you would typically save to database or state management
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock purchase saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      resetForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}