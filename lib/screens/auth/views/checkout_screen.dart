import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/auth/views/providers/cart_provider.dart';
import 'order_success_page.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const Color primaryColor = Color(0xFF0B3B8C);
  static const Color background = Color(0xFFF5F5F7);

  int _qtyOf(Map<String, dynamic> p) {
    final q = p["qty"];
    if (q is int) return q;
    if (q is double) return q.toInt();
    if (q is num) return q.toInt();
    return 1;
  }

  double _priceOf(Map<String, dynamic> p) {
    final pr = p["price"];
    if (pr is double) return pr;
    if (pr is int) return pr.toDouble();
    if (pr is num) return pr.toDouble();
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    double subtotal = 0;
    for (final item in items) {
      if (item is Map<String, dynamic>) {
        subtotal += _priceOf(item) * _qtyOf(item);
      }
    }

    const double deliveryFee = 10.0;
    final double total = items.isEmpty ? 0 : subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : SafeArea(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionTitle('Order Summary'),
                            const SizedBox(height: 8),
                            _buildOrderCard(items),
                            const SizedBox(height: 20),
                            _sectionTitle('Delivery Address'),
                            const SizedBox(height: 8),
                            _buildAddressCard(),
                            const SizedBox(height: 20),
                            _sectionTitle('Payment Method'),
                            const SizedBox(height: 8),
                            _buildPaymentCard(),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomSummary(
                      context,
                      subtotal: subtotal,
                      deliveryFee: deliveryFee,
                      total: total,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ========= Empty state =========
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 56, color: Colors.black38),
            SizedBox(height: 16),
            Text(
              'Your cart is empty.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Add some items before checkout.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========= Section title =========
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  // ========= Order summary card =========
  Widget _buildOrderCard(List<dynamic> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          final qty = _qtyOf(item);
          final price = _priceOf(item);
          final double lineTotal = qty * price;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            title: Text(
              (item["name"] ?? "Item").toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              'Qty: $qty  •  ₪${price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            trailing: Text(
              '₪${lineTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  // ========= Address card =========
  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ramallah, Main Street, Building 12\n'
              'You can later link this with real user addresses.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========= Payment card =========
  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.credit_card, color: primaryColor),
          SizedBox(width: 10),
          Text(
            'Visa •••• 4321',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Text(
            'Change',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ========= Bottom summary + button =========
  Widget _buildBottomSummary(
    BuildContext context, {
    required double subtotal,
    required double deliveryFee,
    required double total,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, -2),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 13),
              ),
              const Spacer(),
              Text(
                '₪${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                'Delivery Fee',
                style: TextStyle(fontSize: 13),
              ),
              const Spacer(),
              Text(
                '₪${deliveryFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                '₪${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Prices are for demo only – you can later connect real taxes & fees.',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrderSuccessPage(total: total),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
