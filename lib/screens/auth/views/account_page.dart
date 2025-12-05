import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'addresses_page.dart';
import 'payment_methods_page.dart';
import 'notifications_page.dart';
import 'help_center_page.dart';
import 'contact_us_page.dart';
import 'language_settings_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const Color primaryColor = Color(0xFF0B3B8C);
  static const Color background = Color(0xFFF5F5F7);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Default language
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AccountPage.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AccountPage.primaryColor,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: settings (dark mode, etc.) later
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 14 * (1 - value)),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(context),

                const SizedBox(height: 16),

                // ===== Quick stats =====
                const Row(
                  children: [
                    Expanded(
                      child: _QuickStatCard(
                        icon: Icons.receipt_long_outlined,
                        label: 'Orders',
                        value: '12',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickStatCard(
                        icon: Icons.favorite_border,
                        label: 'Favorites',
                        value: '5',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickStatCard(
                        icon: Icons.stars_outlined,
                        label: 'Points',
                        value: '320',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const _SectionTitle('Account Settings'),
                const SizedBox(height: 8),

                // ===== Account settings =====
                _AccountTile(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  subtitle: 'Name, email address, phone number',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                ),
                _AccountTile(
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  subtitle: 'Home, work and saved addresses',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddressesPage(),
                      ),
                    );
                  },
                ),
                _AccountTile(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Cards, wallets and other payment options',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PaymentMethodsPage(),
                      ),
                    );
                  },
                ),
                _AccountTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Offers, order updates, app alerts',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),

                // 🔤 Language
                _AccountTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: _openLanguageSettings,
                ),

                const SizedBox(height: 24),

                const _SectionTitle('Help & Support'),
                const SizedBox(height: 8),

                _AccountTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'FAQs and quick answers',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HelpCenterPage(),
                      ),
                    );
                  },
                ),
                _AccountTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contact Us',
                  subtitle: 'Support or send feedback',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ContactUsPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Logout button
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: sign out logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== Header =====
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B3B8C), Color(0xFF3D6DCC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.20),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 34,
              color: AccountPage.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hajar Al-Souqi',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'hajar@example.com',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Smart Cart member – earn points on every purchase.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE3F2FD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ===== Open Language Settings Page =====
  Future<void> _openLanguageSettings() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => LanguageSettingsPage(
          currentLanguage: _selectedLanguage,
        ),
      ),
    );

    if (result != null && result != _selectedLanguage) {
      setState(() {
        _selectedLanguage = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language changed to $_selectedLanguage')),
      );
    }
  }
}

// ===== Helper widgets =====

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AccountPage.primaryColor),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        leading: Icon(icon, color: AccountPage.primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
        onTap: onTap,
      ),
    );
  }
}
