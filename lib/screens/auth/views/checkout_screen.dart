// checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/constants.dart';
import 'providers/cart_provider.dart';
import 'order_success_page.dart';
import 'addresses_page.dart';
import 'payment_methods_page.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final subtotal = cart.totalPrice;
    const double delivery = 10.0; // ممكن تخليه ديناميكي بعدين
    final total = subtotal + delivery;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: blackColor60),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  _SectionHeader(
                    title: 'Delivery address',
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddressesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _AddressCard(
                    title: 'Home',
                    address: 'Nablus Street, Building 12, Apartment 4',
                    phone: '+970 59 000 0000',
                  ),
                  const SizedBox(height: defaultPadding),

                  // طريقة الدفع
                  _SectionHeader(
                    title: 'Payment method',
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentMethodsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const _PaymentCard(
                    method: 'Visa •• 4321',
                    subtitle: 'Default payment method',
                  ),

                  const SizedBox(height: defaultPadding),

                  // ملخص العناصر
                  const Text(
                    'Order items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: defaultPadding / 2),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      final qty = (p['qty'] ?? 1).toInt();
                      final price = (p['price'] ?? 0).toDouble();
                      return _CheckoutItemTile(
                        name: p['name'] ?? 'Product',
                        subtitle: p['desc'] ?? '',
                        qty: qty,
                        price: price,
                      );
                    },
                  ),

                  const SizedBox(height: defaultPadding),

                  // ملخّص الأسعار
                  _SummaryCard(
                    subtotal: subtotal,
                    delivery: delivery,
                    total: total,
                  ),

                  const SizedBox(height: defaultPadding),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // هنا ممكن تحطّي استدعاء API لاحقاً لإرسال الطلب
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderSuccessPage(total: total),
                          ),
                        );
                        cart.clearCart();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadious * 1.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Place order',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;

  const _SectionHeader({
    required this.title,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        if (onEdit != null)
          TextButton(
            onPressed: onEdit,
            child: const Text('Change'),
          ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final String phone;

  const _AddressCard({
    required this.title,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    color: blackColor60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: blackColor60,
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

class _PaymentCard extends StatelessWidget {
  final String method;
  final String subtitle;

  const _PaymentCard({
    required this.method,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: blackColor60,
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

class _CheckoutItemTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final int qty;
  final double price;

  const _CheckoutItemTile({
    required this.name,
    required this.subtitle,
    required this.qty,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final total = price * qty;

    return Container(
      padding: const EdgeInsets.all(defaultPadding / 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: blackColor60,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Qty: $qty',
                  style: const TextStyle(
                    fontSize: 12,
                    color: blackColor60,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "₪${total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;

  const _SummaryCard({
    required this.subtotal,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _row('Subtotal', subtotal),
          const SizedBox(height: 4),
          _row('Delivery', delivery),
          const Divider(height: 18),
          _row(
            'Total',
            total,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Row _row(String label, double value, {bool isBold = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      fontSize: isBold ? 16 : 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          "₪${value.toStringAsFixed(2)}",
          style: style,
        ),
      ],
    );
  }
}
