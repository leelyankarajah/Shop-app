// lib/screens/auth/views/components/sign_up_form.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // ignore: unused_field
  String _fullName = '';
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full name
          Text(
            "Full name",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter your full name",
            ),
            validator: nameValidator,
            onSaved: (value) => _fullName = value!.trim(),
          ),
          const SizedBox(height: defaultPadding),

          // Email
          Text(
            "Email",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "example@mail.com",
            ),
            validator: emaildValidator,
            onSaved: (value) => _email = value!.trim(),
          ),
          const SizedBox(height: defaultPadding),

          // Password
          Text(
            "Password",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          TextFormField(
            obscureText: _passwordObscured,
            decoration: InputDecoration(
              hintText: "Create a password",
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordObscured ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3), // 👈 برضه عدلناها
                ),
                onPressed: () {
                  setState(() {
                    _passwordObscured = !_passwordObscured;
                  });
                },
              ),
            ),
            validator: passwordValidator,
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: defaultPadding),

          // Confirm password
          Text(
            "Confirm password",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: defaultPadding / 2),
          TextFormField(
            obscureText: _confirmPasswordObscured,
            decoration: InputDecoration(
              hintText: "Re-enter your password",
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordObscured
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3),
                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordObscured = !_confirmPasswordObscured;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _password) {
                return 'Passwords do not match';
              }
              return null;
            },
            onSaved: (value) => _confirmPassword = value ?? '',
          ),
        ],
      ),
    );
  }
}
