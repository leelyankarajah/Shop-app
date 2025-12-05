import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'offers_screen.dart';
import 'providers/cart_provider.dart';
import 'account_page.dart';
import 'checkout_screen.dart';     

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  final List<Map<String, dynamic>> mostRequested = [
    {
      "id": "p1",
      "name": "Orange Juice",
      "price": 3.99,
      "stock": true,
      "desc": "1L fresh orange juice, no added sugar.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081967.png",
    },
    {
      "id": "p2",
      "name": "Whole Wheat",
      "price": 2.49,
      "stock": true,
      "desc": "Healthy whole wheat bread, soft and tasty.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081974.png",
    },
    {
      "id": "p3",
      "name": "Pasta",
      "price": 1.99,
      "stock": true,
      "desc": "Italian pasta, perfect for quick meals.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081986.png",
    },
    {
      "id": "p4",
      "name": "Cheddar",
      "price": 4.99,
      "stock": true,
      "desc": "Cheddar cheese block, rich flavor.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081992.png",
    },
  ];

  final List<Map<String, dynamic>> explore = [
    {
      "id": "p5",
      "name": "Strawberries",
      "price": 5.99,
      "stock": true,
      "desc": "Fresh strawberries, 500g pack.",
      "img": "https://cdn-icons-png.flaticon.com/512/590/590685.png",
    },
    {
      "id": "p6",
      "name": "Potatoes",
      "price": 2.99,
      "stock": true,
      "desc": "Local potatoes, 1kg.",
      "img": "https://cdn-icons-png.flaticon.com/512/590/590772.png",
    },
    {
      "id": "p7",
      "name": "Olive Oil",
      "price": 6.99,
      "stock": true,
      "desc": "Extra virgin olive oil, 750ml.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081992.png",
    },
    {
      "id": "p8",
      "name": "Cufanarons",
      "price": 5.99,
      "stock": true,
      "desc": "Sweet dessert box, family size.",
      "img": "https://cdn-icons-png.flaticon.com/512/3081/3081992.png",
    },
  ];
  List<Map<String, dynamic>> _filterList(List<Map<String, dynamic>> list) {
    final q = searchController.text.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list
        .where((p) => (p['name'] ?? '').toString().toLowerCase().contains(q))
        .toList();
  }

  void showProductDetails(Map<String, dynamic> p) {
    final cart = context.read<CartProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(p["name"] ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              p["img"] ?? "",
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 48),
            ),
            const SizedBox(height: 10),
            Text("Price: ₪${p["price"]}"),
            const SizedBox(height: 6),
            Text(p["desc"] ?? '', style: const TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              cart.addProduct(Map<String, dynamic>.from(p));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${p["name"]} added to cart 🛒")),
              );
            },
            child: const Text("Add to cart"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B3B8C);
    final cartProvider = context.watch<CartProvider>();

    final filteredMost = _filterList(mostRequested);
    final filteredExplore = _filterList(explore);

    // ===== كل الصفحات داخل IndexedStack =====
    final List<Widget> pages = [
      // الصفحة الرئيسية
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Most Requested Products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredMost.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final p = filteredMost[i];
                  return _ProductCard(
                    product: p,
                    onTap: () => showProductDetails(p),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Explore Products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredExplore.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, i) {
                final p = filteredExplore[i];
                return _ProductCard(
                  product: p,
                  onTap: () => showProductDetails(p),
                );
              },
            ),
          ],
        ),
      ),

      // صفحة الكارت
      const CartScreen(),

      // صفحة العروض
      const OffersScreen(),

      // صفحة الحساب
      const AccountPage(),

      // صفحة الدفع
const CheckoutScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (navIndex == 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shopping_bag, color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Smart\nShopping Hub",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: "Search products",
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => searchController.clear(),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: navIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        selectedItemColor: blue,
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => navIndex = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartProvider.items.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${cartProvider.items.length}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.percent),
            label: "Offers",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: "Checkout",
          ),
        ],
      ),
    );
  }
}

// ====== Product Card ======
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B3B8C);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product["img"] ?? "",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product["name"] ?? "Item",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              "₪${product["price"]}",
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w800, color: blue),
            ),
          ],
        ),
      ),
    );
  }
}
