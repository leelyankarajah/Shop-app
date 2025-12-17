import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';
import 'offers_screen.dart';
import 'account_page.dart';
import 'package:shop/screens/auth/views/providers/cart_provider.dart';
import 'package:shop/providers/owner_provider.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerProvider>();
    final products = owner.products.where((p) {
      final q = _searchQuery.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.brandName.toLowerCase().contains(q);
    }).toList();

    final pages = <Widget>[
      _HomeTab(
        products: products,
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
      const OffersScreen(),
      const CartScreen(),
      const AccountPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print('Bottom nav tapped: $index');
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: blackColor60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            activeIcon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<String> onSearchChanged;

  const _HomeTab({
    required this.products,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Cart'),
        centerTitle: false,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  print('Cart icon pressed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          Text(
            'Hello, welcome 👋',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Discover fresh groceries and daily essentials.',
            style: TextStyle(
              color: blackColor60,
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Search
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search for milk, bread, eggs...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onSearchChanged,
          ),

          const SizedBox(height: defaultPadding),

          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No products available',
                  style: TextStyle(color: blackColor60),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductCard(product: product);
              },
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final owner = context.read<OwnerProvider>();

    final double priceToShow = product.priceAfetDiscount ?? product.price;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadious * 1.4),
                topRight: Radius.circular(defaultBorderRadious * 1.4),
              ),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: blackColor5,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: blackColor40,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding / 1.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: blackColor60,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₪${priceToShow.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Add button pressed for ${product.title}');
                          cart.addProduct({
                            'id': product.id,
                            'name': product.title,
                            'price': priceToShow,
                            'img': product.image,
                            'qty': 1,
                          });
                          owner.addOrder(product.id, quantity: 1);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${product.title} added to cart'),
                              behavior: SnackBarBehavior.floating,
                              duration:
                                  const Duration(milliseconds: 900),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
