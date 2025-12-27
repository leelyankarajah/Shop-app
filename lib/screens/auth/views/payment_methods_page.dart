// lib/screens/auth/views/payment_methods_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shop/constants.dart';
import 'package:shop/components/card_info.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() =>
      _PaymentMethodsPageState();
}

class _PaymentMethodsPageState
    extends State<PaymentMethodsPage> {
  final _auth = FirebaseAuth.instance;
  DatabaseReference? _methodsRef;

  bool _loading = true;
  List<_PaymentMethod> _methods = [];

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  Future<void> _loadMethods() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _methodsRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/paymentMethods');

    try {
      final snap = await _methodsRef!.get();
      final List<_PaymentMethod> items = [];

      if (snap.exists) {
        for (final child in snap.children) {
          final id = child.key ?? '';
          final value = child.value;
          if (value is Map) {
            final data = Map<Object?, Object?>.from(value);
            items.add(
              _PaymentMethod(
                id: id,
                alias: data['alias']?.toString() ?? 'Card',
                brand: data['brand']?.toString() ?? 'Card',
                last4: data['last4']?.toString() ?? '0000',
                expiry: data['expiry']?.toString() ?? '',
                isDefault:
                    (data['isDefault'] as bool?) ??
                        false,
              ),
            );
          }
        }
      }

      setState(() {
        _methods = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setDefault(String id) async {
    if (_methodsRef == null) return;

    setState(() {
      _methods = _methods
          .map((m) => m.copyWith(isDefault: m.id == id))
          .toList();
    });

    for (final m in _methods) {
      await _methodsRef!
          .child(m.id)
          .update({'isDefault': m.isDefault});
    }
  }

  Future<void> _deleteMethod(String id) async {
    if (_methodsRef == null) return;

    await _methodsRef!.child(id).remove();
    setState(() {
      _methods.removeWhere((m) => m.id == id);
    });
  }

  Future<void> _openMethodForm({_PaymentMethod? existing}) async {
    final result =
        await showDialog<_PaymentMethod>(
      context: context,
      builder: (ctx) =>
          _PaymentMethodDialog(existing: existing),
    );

    if (result == null || _methodsRef == null) return;

    if (existing == null) {
      final newRef = _methodsRef!.push();
      final id = newRef.key!;
      final toSave = result.copyWith(id: id);

      await newRef.set(toSave.toMap());

      setState(() {
        _methods.add(toSave);
      });

      if (toSave.isDefault) {
        await _setDefault(id);
      }
    } else {
      await _methodsRef!.child(existing.id).update(
            result.toMap()..remove('id'),
          );

      setState(() {
        _methods = _methods.map((m) {
          if (m.id == existing.id) {
            return result.copyWith(id: existing.id);
          }
          return m;
        }).toList();
      });

      if (result.isDefault) {
        await _setDefault(existing.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Payment methods',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _openMethodForm(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_methods.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'You have no saved payment methods.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: _methods.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final m = _methods[index];
                          return GestureDetector(
                            onTap: () =>
                                _openMethodForm(
                              existing: m,
                            ),
                            child: Stack(
                              children: [
                                CardInfo(
                                  last4Digits: m.last4,
                                  name: m.alias,
                                  expiryDate:
                                      m.expiry.isEmpty
                                          ? '--/--'
                                          : m.expiry,
                                  isSelected:
                                      m.isDefault,
                                  press: () =>
                                      _setDefault(m.id),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons
                                          .delete_outline,
                                      color:
                                          Colors.white,
                                    ),
                                    onPressed: () =>
                                        _deleteMethod(
                                            m.id),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'For demo only – no real payment is processed.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String alias;
  final String brand;
  final String last4;
  final String expiry;
  final bool isDefault;

  _PaymentMethod({
    required this.id,
    required this.alias,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.isDefault,
  });

  _PaymentMethod copyWith({
    String? id,
    String? alias,
    String? brand,
    String? last4,
    String? expiry,
    bool? isDefault,
  }) {
    return _PaymentMethod(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expiry: expiry ?? this.expiry,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alias': alias,
      'brand': brand,
      'last4': last4,
      'expiry': expiry,
      'isDefault': isDefault,
    };
  }
}

class _PaymentMethodDialog extends StatefulWidget {
  final _PaymentMethod? existing;

  const _PaymentMethodDialog({this.existing});

  @override
  State<_PaymentMethodDialog> createState() =>
      _PaymentMethodDialogState();
}

class _PaymentMethodDialogState
    extends State<_PaymentMethodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();
  final _brandController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();

  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    if (m != null) {
      _aliasController.text = m.alias;
      _brandController.text = m.brand;
      _numberController.text =
          '**** **** **** ${m.last4}';
      _expiryController.text = m.expiry;
      _isDefault = m.isDefault;
    }
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _brandController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final number = _numberController.text
        .replaceAll(' ', '')
        .replaceAll('*', '');
    String last4 = widget.existing?.last4 ?? '0000';

    if (number.length >= 4 &&
        RegExp(r'^[0-9]+$').hasMatch(number)) {
      last4 = number.substring(number.length - 4);
    }

    final method = _PaymentMethod(
      id: widget.existing?.id ?? '',
      alias:
          _aliasController.text.trim().isEmpty
              ? 'Card'
              : _aliasController.text.trim(),
      brand:
          _brandController.text.trim().isEmpty
              ? 'Card'
              : _brandController.text.trim(),
      last4: last4,
      expiry: _expiryController.text.trim(),
      isDefault: _isDefault,
    );

    Navigator.of(context).pop(method);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null
            ? 'Add payment method'
            : 'Edit payment method',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: 'Card name (e.g. Personal)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand (Visa, MasterCard...)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Card number (demo only)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry (MM/YY)',
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _isDefault,
                onChanged: (v) {
                  setState(() {
                    _isDefault = v ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Set as default payment method',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
