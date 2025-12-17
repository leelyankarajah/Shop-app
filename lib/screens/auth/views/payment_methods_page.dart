import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/components/card_info.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

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
        children: [
          Text(
            'Saved cards',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),

          // بطاقات محفوطة - تصميم احترافي باستخدام CardInfo
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CardInfo(
                    last4Digits: '4321',
                    name: 'Hajar Al-Souqi',
                    expiryDate: '08/26',
                    isSelected: true,
                  ),
                  SizedBox(height: 16),
                  CardInfo(
                    last4Digits: '9988',
                    name: 'Hajar Al-Souqi',
                    expiryDate: '01/25',
                    bgColor: darkGreyColor,
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: open add-card form later
              },
              icon: const Icon(Icons.add),
              label: const Text('Add new card'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'For demo only – no real payment is processed.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}
