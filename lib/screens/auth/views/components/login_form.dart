// lib/screens/auth/views/components/login_form.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              hintText: "Enter your password",
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordObscured ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3), // 👈 كانت هي اللي معطية Error
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
        ],
      ),
    );
  }
}
