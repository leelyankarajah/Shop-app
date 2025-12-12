import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool offers = true;
  bool orders = true;
  bool appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Push notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Offers & discounts'),
                  subtitle: const Text(
                    'Receive alerts when new offers and coupons are available.',
                  ),
                  value: offers,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => offers = v),
                ),
                const Divider(height: 0),
                SwitchListTile.adaptive(
                  title: const Text('Order updates'),
                  subtitle: const Text(
                    'Track order preparation, shipping and delivery status.',
                  ),
                  value: orders,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => orders = v),
                ),
                const Divider(height: 0),
                SwitchListTile.adaptive(
                  title: const Text('App updates'),
                  subtitle: const Text(
                    'Get notified about new features and important changes.',
                  ),
                  value: appUpdates,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => appUpdates = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'You can change these settings at any time.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}
