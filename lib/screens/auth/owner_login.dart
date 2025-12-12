// owner_login.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';

class OwnerLogin extends StatelessWidget {
  const OwnerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const OwnerLoginBody();
  }
}

// أسماء بديلة عشان أي اسم مستخدم في الراوتر يكون موجود
class OwnerLoginScreen extends StatelessWidget {
  const OwnerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OwnerLoginBody();
  }
}

class OwnerLoginPage extends StatelessWidget {
  const OwnerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OwnerLoginBody();
  }
}

class OwnerLoginBody extends StatefulWidget {
  const OwnerLoginBody({super.key});

  @override
  State<OwnerLoginBody> createState() => _OwnerLoginBodyState();
}

class _OwnerLoginBodyState extends State<OwnerLoginBody> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  // ignore: unused_field
  String _password = '';
  bool _obscured = true;

  void _onLoginOwner() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged in as owner ($_email) – demo only'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      Navigator.pushReplacementNamed(context, ownerDashboardRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop owner area',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Log in to manage products, visitors and performance.',
              style: TextStyle(
                fontSize: 13,
                color: blackColor60,
              ),
            ),

            const SizedBox(height: defaultPadding * 1.2),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'owner@shop.com',
                    ),
                    validator: emaildValidator,
                    onSaved: (v) => _email = (v ?? '').trim(),
                  ),

                  const SizedBox(height: defaultPadding),

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    obscureText: _obscured,
                    decoration: InputDecoration(
                      hintText: 'Enter your owner password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.textTheme.bodyLarge?.color
                              ?.withOpacity(0.4),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscured = !_obscured;
                          });
                        },
                      ),
                    ),
                    validator: passwordValidator,
                    onSaved: (v) => _password = v ?? '',
                  ),
                ],
              ),
            ),

            const SizedBox(height: defaultPadding * 1.5),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onLoginOwner,
                child: const Text(
                  'Log in as shop owner',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: defaultPadding / 2),

            Center(
              child: Text(
                'This is a demo login – no real backend is connected yet.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: blackColor60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
