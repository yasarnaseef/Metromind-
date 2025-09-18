import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'product_details_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _searchFocusNode = FocusNode();
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _searchFocusNode.unfocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title:  Text('Products',style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),),
        actions: [
          Consumer<ProductProvider>(
              builder: (context,productPro,child) {
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  productPro.clearProductDetails();
                  Product product = Product(
                    name: '',
                    description: '',
                    price: 0.0,
                    costPrice: 0.0,
                    quantity: 0,
                    categories: [], id: '', imageUrl: '',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  ProductFormScreen(product:product,fromWhere: 'Add' ,)),
                  );
                },
              );
            }
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: const InputDecoration(
          //       labelText: 'Search Products',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(),
          //     ),
          //     onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          //   ),
          // ),

          Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 16),
            child: SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search orders by customer name...',
              leading: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              trailing: _searchQuery.isNotEmpty
                  ? [
                IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _clearSearch,
                ),
              ]
                  : null,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
              backgroundColor: WidgetStateProperty.all(
                colorScheme.surfaceContainerHighest,
              ),
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: Provider.of<ProductProvider>(context).getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                final filteredProducts = snapshot.data!
                    .where((product) => product.name.toLowerCase().contains(_searchQuery))
                    .toList();
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductListItem(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: const Icon(Icons.broken_image, size: 30),
                  ),
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: const Icon(Icons.image, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(2)} | Qty: ${product.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Trailing Icon for visual cue
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}