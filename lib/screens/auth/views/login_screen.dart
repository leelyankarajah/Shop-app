// lib/screens/auth/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onLoginPressed(BuildContext context) {
    final form = _formKey.currentState;
    if (!(form?.validate() ?? false)) return;

    form!.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged in (demo only)'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacementNamed(context, homeScreenRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // الصورة العلوية
            SizedBox(
              height: size.height * 0.30,
              width: double.infinity,
              child: Image.asset(
                "assets/images/cart.png",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.shopping_cart_outlined,
                  size: 50,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Text(
                      "Log in to continue shopping with Smart Cart.",
                    ),
                    const SizedBox(height: defaultPadding),

                    // الفورم
                    LogInForm(formKey: _formKey),

                    const SizedBox(height: defaultPadding / 2),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, forgotPasswordScreenRoute);
                        },
                        child: const Text("Forgot password?"),
                      ),
                    ),

                    const SizedBox(height: defaultPadding),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onLoginPressed(context),
                        child: const Text("Log in"),
                      ),
                    ),

                    const SizedBox(height: defaultPadding / 2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, signUpScreenRoute);
                          },
                          child: const Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
