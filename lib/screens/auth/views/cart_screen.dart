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

  void _applyCoupon(BuildContext context) {
    final code = _couponController.text.trim().toLowerCase();
    context.read<CartProvider>();

    if (code == 'save10') {
      setState(() => _discount = 0.10);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon applied: 10% off')));
    } else if (code == 'save20') {
      setState(() => _discount = 0.20);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon applied: 20% off')));
    } else {
      setState(() => _discount = 0.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon')));
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
                      final qty = p['qty'] ?? 1;
                      final price = p['price'] ?? 0.0;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: p['img'] != null
                              ? Image.network(p['img'], width: 50, height: 50)
                              : const Icon(Icons.image_not_supported),
                          title: Text(p['name'] ?? "Unknown"),
                          subtitle: Text('Price: ₪${price.toStringAsFixed(2)} x $qty'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () {
                                  if (qty > 1) {
                                    cartProvider.updateQty(p['id'], qty - 1);
                                  } else {
                                    cartProvider.removeProduct(p['id']);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => cartProvider.updateQty(p['id'], qty + 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(hintText: "Coupon code"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _applyCoupon(context),
                            style: ElevatedButton.styleFrom(backgroundColor: blue),
                            child: const Text("Apply"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                          const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("₪${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
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
