import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile image) async {
    try {
      Reference ref = _storage.ref().child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<void> addProduct(Product product, XFile? image) async {
    String docId=DateTime.now().microsecondsSinceEpoch.toString();
    try {
      String imageUrl = '';
      if (image != null) {
        // imageUrl = await uploadImage(image);
      }
      await _firestore.collection('products').doc(docId).set({
        ...product.toMap(),
        'productId': docId,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Add product failed: $e');
    }
  }

  Future<void> updateProduct(Product product, XFile? image) async {
    try {
      String imageUrl = product.imageUrl;
      if (image != null) {
        // imageUrl = await uploadImage(image);
      }
      await _firestore.collection('products').doc(product.id).update({
        ...product.toMap(),
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Update product failed: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      throw Exception('Delete product failed: $e');
    }
  }

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList());
  }
}