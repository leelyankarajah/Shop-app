// account_page.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

import 'edit_profile_page.dart';
import 'addresses_page.dart';
import 'payment_methods_page.dart';
import 'notifications_page.dart';
import 'language_settings_page.dart';
import 'help_center_page.dart';
import 'contact_us_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = 'Guest user'; // لاحقاً اربطيها بالـ Auth
    const String email = 'guest@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          // معلومات المستخدم
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultBorderRadious * 1.5),
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
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: primaryColor,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: blackColor60,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),

          const SizedBox(height: defaultPadding * 1.5),

          const Text(
            'Account settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),

          _tile(
            context,
            icon: Icons.location_on_outlined,
            title: 'My addresses',
            subtitle: 'Manage your delivery addresses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddressesPage(),
                ),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.credit_card_outlined,
            title: 'Payment methods',
            subtitle: 'View and edit your cards',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentMethodsPage(),
                ),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Offers, updates and alerts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LanguageSettingsPage(currentLanguage: 'English'),
                ),
              );
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to $result (demo only)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),

          const SizedBox(height: defaultPadding),

          const Text(
            'Support',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),

          _tile(
            context,
            icon: Icons.help_outline,
            title: 'Help center',
            subtitle: 'FAQ and app help',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpCenterPage(),
                ),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.mail_outline,
            title: 'Contact us',
            subtitle: 'Send us your feedback',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContactUsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: defaultPadding),

          _tile(
            context,
            icon: Icons.logout,
            title: 'Log out',
            subtitle: 'Sign out from this device',
            color: Colors.red,
            onTap: () {
              // TODO: اربطيه بالـ Auth لاحقاً
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out (demo only)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    VoidCallback? onTap,
  }) {
    final iconColor = color ?? blackColor80;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: iconColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: blackColor60,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
