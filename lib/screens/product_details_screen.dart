import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
 // Assuming Product model is defined
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'product_form_screen.dart'; // Assuming ProductFormScreen is defined


class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Product',
            onPressed: () async {
              try {
                await Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(product.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Product deleted successfully'),
                      backgroundColor: theme.colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: theme.colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Product',
            onPressed: () {
              Share.share(
                'Name: ${product.name}\nPrice: ₹${product.price}\nDescription: ${product.description}',
                subject: product.name,
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: theme.colorScheme.surfaceContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                product.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: theme.colorScheme.surfaceContainer,
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              )
                  : Container(
                height: 250,
                color: theme.colorScheme.surfaceContainer,
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    semanticsLabel: 'Product name: ${product.name}',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Price: ₹${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: ${product.quantity}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Categories: ${product.categories.join(", ")}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Description: ${product.description}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  // Cost price hidden as per requirements
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Consumer<ProductProvider>(
              builder: (context,productPro,child) {
              return FilledButton(
                onPressed: () {
                  productPro.setProductDetails(product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductFormScreen(product: product,fromWhere: 'Edit',),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit Product'),
              );
            }
          ),
        ],
      ),
    );
  }
}