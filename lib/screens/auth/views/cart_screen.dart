import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/auth/views/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  double _discount = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toLowerCase();

    if (code == 'save10') {
      setState(() => _discount = 0.10);
    } else if (code == 'save20') {
      setState(() => _discount = 0.20);
    } else {
      setState(() => _discount = 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B3B8C);
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.items;

    final subtotal = cartProvider.totalPrice;
    final discountAmount = subtotal * _discount;
    final total = subtotal - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: blue,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final p = cart[index];
                      final qty = (p['qty'] ?? 1).toInt();
                      final price = (p['price'] ?? 0).toDouble();

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: p['img'] != null
                              ? Image.network(p['img'], width: 50, height: 50)
                              : const Icon(Icons.image_not_supported),
                          title: Text(p['name']),
                          subtitle: Text(
                              'Price: ₪${price.toStringAsFixed(2)} x $qty'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (qty > 1) {
                                    cartProvider.updateQty(p['id'], qty - 1);
                                  } else {
                                    cartProvider.removeProduct(p['id']);
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () =>
                                    cartProvider.updateQty(p['id'], qty + 1),
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// BOTTOM SECTION (fixed)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(
                                hintText: "Coupon code",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _applyCoupon,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              child: const Text("Apply"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("₪${subtotal.toStringAsFixed(2)}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Discount"),
                          Text("- ₪${discountAmount.toStringAsFixed(2)}"),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("₪${total.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
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
