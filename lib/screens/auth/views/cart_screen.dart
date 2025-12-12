import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/auth/views/providers/cart_provider.dart';
import 'package:shop/constants.dart';

import 'checkout_screen.dart';

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
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // Demo فقط: كوبون تجريبي
    if (code == "SMART10") {
      setState(() {
        _discount = 0.10; // 10%
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon SMART10 applied (10% off)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _discount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final subtotal = cartProvider.totalPrice;
    final discountAmount = subtotal * _discount;
    final total = subtotal - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(
                  fontSize: 16,
                  color: blackColor60,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(defaultPadding),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: defaultPadding / 2),
                    itemBuilder: (context, index) {
                      final product = items[index];
                      final id = product['id']?.toString() ?? '';
                      final name = product['name']?.toString() ?? 'Product';
                      final price =
                          (product['price'] ?? 0).toDouble();
                      final qty = (product['qty'] ?? 1).toInt();
                      final img = product['img']?.toString() ?? '';

                      return Dismissible(
                        key: ValueKey(id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          decoration: BoxDecoration(
                            color: errorColor,
                            borderRadius: BorderRadius.circular(
                                defaultBorderRadious),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          cartProvider.removeProduct(id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding / 1.2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                defaultBorderRadious),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    defaultBorderRadious),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: img.isEmpty
                                      ? Container(
                                          color: blackColor5,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.image,
                                            color: blackColor40,
                                          ),
                                        )
                                      : Image.network(
                                          img,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: defaultPadding),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₪${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              // Qty controls
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(999),
                                      border: Border.all(
                                        color: blackColor20,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            cartProvider.updateQty(
                                                id, qty - 1);
                                          },
                                          iconSize: 18,
                                          splashRadius: 18,
                                          icon: const Icon(
                                              Icons.remove_rounded),
                                        ),
                                        Text(
                                          '$qty',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            cartProvider.updateQty(
                                                id, qty + 1);
                                          },
                                          iconSize: 18,
                                          splashRadius: 18,
                                          icon: const Icon(
                                              Icons.add_rounded),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₪${(price * qty).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom summary
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: blackColor10,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Coupon
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(
                                hintText: 'Enter coupon code',
                              ),
                            ),
                          ),
                          const SizedBox(width: defaultPadding / 2),
                          TextButton(
                            onPressed: _applyCoupon,
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text(
                            '₪${subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_discount > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Discount',
                              style: TextStyle(color: primaryColor),
                            ),
                            Text(
                              '-₪${discountAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '₪${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          child: const Text('Proceed to checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
