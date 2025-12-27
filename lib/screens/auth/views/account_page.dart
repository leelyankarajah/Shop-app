import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shop/constants.dart';
import 'addresses_page.dart';
import 'payment_methods_page.dart';
import 'notifications_page.dart';
import 'language_settings_page.dart';
import 'help_center_page.dart';
import 'contact_us_page.dart';
import 'edit_profile_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _auth = FirebaseAuth.instance;
  DatabaseReference? _userRef;

  String _name = 'Guest user';
  String _email = '';
  String _phone = '';
  String _city = '';
  String _language = 'English';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _name = 'Guest user';
        _email = '';
        _loading = false;
      });
      return;
    }

    _email = user.email ?? '';
    _userRef = FirebaseDatabase.instance.ref('users/${user.uid}');

    try {
      final snap = await _userRef!.get();
      if (snap.exists && snap.value is Map) {
        final data = Map<Object?, Object?>.from(snap.value as Map);
        _name = data['name']?.toString() ?? _name;
        _phone = data['phone']?.toString() ?? _phone;
        _city = data['city']?.toString() ?? _city;
        _language = data['language']?.toString() ?? _language;
      }
    } catch (_) {
      // بنخلي الديفولت لو صار خطأ
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
    });
    await _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildAccountSection(context),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 24),
            _buildHelpSection(context),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final avatarLetter =
        _name.isNotEmpty ? _name.trim()[0].toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Text(
              avatarLetter,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                if (_phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _phone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
                if (_city.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _city,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              );

              if (changed == true) {
                _refresh();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconBg,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.2),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: iconBg ?? primaryColor.withOpacity(0.08),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              )
            : null,
        trailing: trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black26,
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Account'),
        _buildTile(
          icon: Icons.person_outline,
          title: 'Profile information',
          subtitle: 'Name, phone, city',
          onTap: () async {
            final changed = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => const EditProfilePage(),
              ),
            );
            if (changed == true) {
              _refresh();
            }
          },
        ),
        _buildTile(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          subtitle: 'Delivery addresses',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddressesPage(),
              ),
            );
          },
        ),
        _buildTile(
          icon: Icons.credit_card_outlined,
          title: 'Payment methods',
          subtitle: 'Cards and wallets',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PaymentMethodsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Preferences'),
        _buildTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: 'Promos, order updates',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationsPage(),
              ),
            );
          },
        ),
        _buildTile(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: _language,
          trailing: Text(
            _language,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          onTap: () async {
            final selected = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LanguageSettingsPage(currentLanguage: _language),
              ),
            );

            if (selected != null && selected != _language) {
              setState(() {
                _language = selected;
              });

              final user = _auth.currentUser;
              if (user != null) {
                await FirebaseDatabase.instance
                    .ref('users/${user.uid}/language')
                    .set(selected);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support'),
        _buildTile(
          icon: Icons.help_outline_rounded,
          title: 'Help center',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HelpCenterPage(),
              ),
            );
          },
        ),
        _buildTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Contact us',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ContactUsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return TextButton.icon(
      onPressed: () async {
        await _auth.signOut();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            duration: Duration(milliseconds: 900),
          ),
        );

        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.redAccent,
      ),
      label: const Text(
        'Log out',
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
