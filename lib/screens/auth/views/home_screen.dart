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
    final cart = context.watch<CartProvider>();
    final owner = context.watch<OwnerProvider>();

    final allProducts = owner.products;

    final q = _searchQuery.trim().toLowerCase();
    final List<ProductModel> filteredProducts = q.isEmpty
        ? allProducts
        : allProducts.where((p) {
            return p.title.toLowerCase().contains(q) ||
                p.brandName.toLowerCase().contains(q);
          }).toList();

    Widget body;

    switch (_currentIndex) {
      case 0:
        body = _HomeTab(
          products: filteredProducts,
          searchQuery: _searchQuery,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          cartItemCount: cart.items.length,
        );
        break;
      case 1:
        body = const OffersScreen();
        break;
      case 2:
        body = const CartScreen();
        break;
      case 3:
      default:
        body = const AccountPage();
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: blackColor40,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

/// التاب الرئيسية (الواجهة الأولى مع البحث والمنتجات)
class _HomeTab extends StatelessWidget {
  final List<ProductModel> products;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final int cartItemCount;

  const _HomeTab({
    super.key,
    required this.products,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: defaultPadding * 0.8),

          // العنوان + أيقونة الكارت الصغيرة
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              children: [
                Text(
                  'Supermarket',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CartScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                    ),
                    if (cartItemCount > 0)
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
                            '$cartItemCount',
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
          ),

          const SizedBox(height: defaultPadding * 0.5),

          // مربع البحث
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          const SizedBox(height: defaultPadding),

          // المنتجات
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'No products available yet.',
                        style: TextStyle(
                          color: blackColor60,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductCard(product: product);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// كرت المنتج (مرتبط بالكارت والـ OwnerProvider)
class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final owner = context.read<OwnerProvider>();

    final double priceToShow =
        product.priceAfetDiscount ?? product.price;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(defaultBorderRadious * 1.4),
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
          // صورة المنتج
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft:
                    Radius.circular(defaultBorderRadious * 1.4),
                topRight:
                    Radius.circular(defaultBorderRadious * 1.4),
              ),
              child: Image.network(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: blackColor5,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 32,
                      color: blackColor40,
                    ),
                  );
                },
              ),
            ),
          ),

          // المحتوى (الاسم + البراند + السعر + زر الإضافة)
          Padding(
            padding: const EdgeInsets.all(defaultPadding / 1.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المنتج
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),

                // البراند
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

                // السعر + زر Add
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
                          if (product.stock <= 0 ||
                              product.available == false) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'This product is out of stock.',
                                ),
                                behavior:
                                    SnackBarBehavior.floating,
                                duration:
                                    Duration(milliseconds: 900),
                              ),
                            );
                            return;
                          }

                          cart.addProduct({
                            'id': product.id,
                            'name': product.title,
                            'price': priceToShow,
                            'img': product.image,
                            'qty': 1,
                          });

                          owner.addOrder(
                            product.id,
                            quantity: 1,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${product.title} added to cart'),
                              behavior:
                                  SnackBarBehavior.floating,
                              duration: const Duration(
                                  milliseconds: 900),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(999),
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
