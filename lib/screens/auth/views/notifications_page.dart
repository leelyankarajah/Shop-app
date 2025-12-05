import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool offers = true;
  bool orders = true;
  bool appUpdates = true;

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
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Offers & Discounts'),
            subtitle: const Text('Receive alerts when new offers are available'),
            value: offers,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => offers = v),
          ),
          const Divider(height: 0),

          SwitchListTile.adaptive(
            title: const Text('Order Updates'),
            subtitle: const Text('Track order preparation and delivery'),
            value: orders,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => orders = v),
          ),
          const Divider(height: 0),

          SwitchListTile.adaptive(
            title: const Text('App Updates'),
            subtitle: const Text('Get notified about new features and improvements'),
            value: appUpdates,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => appUpdates = v),
          ),
        ],
      ),
    );
  }
}
