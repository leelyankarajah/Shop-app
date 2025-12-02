import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const Color primaryColor = Color(0xFF0B3B8C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('How do I use the Smart Cart?'),
            subtitle: Text('Scan the products, then review and complete your order from the cart page.'),
          ),
          Divider(),
          ListTile(
            title: Text('Can I cancel my order?'),
            subtitle: Text('You can cancel before payment is confirmed. After payment, please contact support.'),
          ),
        ],
      ),
    );
  }
}
