// lib/screens/auth/views/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _sendReset() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reset link sent to $_email (demo only)'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacementNamed(context, logInScreenRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address and we will send you a link to reset your password.',
              style: TextStyle(
                fontSize: 13,
                color: blackColor60,
                height: 1.4,
              ),
            ),
            const SizedBox(height: defaultPadding),

            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'example@mail.com',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: emaildValidator,
                onSaved: (value) => _email = value!.trim(),
              ),
            ),

            const SizedBox(height: defaultPadding * 1.5),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendReset,
                child: const Text('Send reset link'),
              ),
            ),

            const SizedBox(height: defaultPadding / 2),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, logInScreenRoute);
                },
                child: const Text('Back to login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
