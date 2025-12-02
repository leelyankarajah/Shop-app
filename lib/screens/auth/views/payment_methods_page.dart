import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

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
          'Payment Methods',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Visa •••• 4321'),
            subtitle: Text('Hajar Al-Souqi'),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('MasterCard •••• 9988'),
            subtitle: Text('Hajar Al-Souqi'),
          ),
        ],
      ),
    );
  }
}
