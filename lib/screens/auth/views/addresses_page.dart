// lib/screens/auth/views/addresses_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shop/constants.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final _auth = FirebaseAuth.instance;
  DatabaseReference? _addressesRef;

  bool _loading = true;
  List<_Address> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    _addressesRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/addresses');

    try {
      final snap = await _addressesRef!.get();
      final List<_Address> items = [];

      if (snap.exists) {
        for (final child in snap.children) {
          final id = child.key ?? '';
          final value = child.value;
          if (value is Map) {
            final data = Map<Object?, Object?>.from(value);
            items.add(_Address(
              id: id,
              label: data['label']?.toString() ?? 'Address',
              details: data['details']?.toString() ?? '',
              city: data['city']?.toString() ?? '',
              phone: data['phone']?.toString() ?? '',
              isDefault:
                  (data['isDefault'] as bool?) ?? false,
            ));
          }
        }
      }

      setState(() {
        _addresses = items;
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
    if (_addressesRef == null) return;

    // Update locally
    setState(() {
      _addresses = _addresses
          .map((a) => a.copyWith(isDefault: a.id == id))
          .toList();
    });

    // Update in Realtime Database
    for (final a in _addresses) {
      await _addressesRef!
          .child(a.id)
          .update({'isDefault': a.isDefault});
    }
  }

  Future<void> _deleteAddress(String id) async {
    if (_addressesRef == null) return;

    await _addressesRef!.child(id).remove();
    setState(() {
      _addresses.removeWhere((a) => a.id == id);
    });
  }

  Future<void> _openAddressForm({_Address? existing}) async {
    final result = await showModalBottomSheet<_Address>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return _AddressFormSheet(existing: existing);
      },
    );

    if (result == null || _addressesRef == null) return;

    if (existing == null) {
      // Add new
      final newRef = _addressesRef!.push();
      final id = newRef.key!;
      final toSave = result.copyWith(id: id);

      await newRef.set(toSave.toMap());

      setState(() {
        _addresses.add(toSave);
      });

      if (toSave.isDefault) {
        await _setDefault(id);
      }
    } else {
      // Update existing
      await _addressesRef!.child(existing.id).update(
            result.toMap()
              ..remove('id'),
          );

      setState(() {
        _addresses = _addresses.map((a) {
          if (a.id == existing.id) {
            return result.copyWith(id: existing.id);
          }
          return a;
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
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: const Text(
          'My addresses',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => _openAddressForm(),
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? Center(
                  child: Text(
                    'You don\'t have any saved addresses yet.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: blackColor60),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(defaultPadding),
                  itemCount: _addresses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: defaultPadding / 1.4),
                  itemBuilder: (context, index) {
                    final a = _addresses[index];
                    return Dismissible(
                      key: ValueKey(a.id),
                      direction:
                          DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(
                            right: defaultPadding),
                        color: Colors.redAccent,
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (ctx) =>
                                  AlertDialog(
                                title:
                                    const Text('Delete address'),
                                content: const Text(
                                  'Are you sure you want to delete this address?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            ctx, false),
                                    child:
                                        const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            ctx, true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                          color:
                                              Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                      },
                      onDismissed: (_) =>
                          _deleteAddress(a.id),
                      child: Container(
                        padding:
                            const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            defaultBorderRadious * 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.03),
                              blurRadius: 10,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        a.label,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                      if (a.isDefault)
                                        Container(
                                          margin:
                                              const EdgeInsets
                                                  .only(
                                            left: 8,
                                          ),
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: primaryColor
                                                .withOpacity(
                                                    0.08),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              20,
                                            ),
                                          ),
                                          child:
                                              const Text(
                                            'Default',
                                            style:
                                                TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                              color:
                                                  primaryColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: 4),
                                  Text(
                                    a.details,
                                    style:
                                        const TextStyle(
                                      fontSize: 13,
                                      color: blackColor60,
                                    ),
                                  ),
                                  if (a.city
                                      .trim()
                                      .isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsets
                                              .only(
                                        top: 2,
                                      ),
                                      child: Text(
                                        a.city,
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          color:
                                              blackColor40,
                                        ),
                                      ),
                                    ),
                                  if (a.phone
                                      .trim()
                                      .isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsets
                                              .only(
                                        top: 2,
                                      ),
                                      child: Text(
                                        a.phone,
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          color:
                                              blackColor40,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _openAddressForm(
                                existing: a,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                a.isDefault
                                    ? Icons
                                        .star_rounded
                                    : Icons
                                        .star_border_rounded,
                                color: a.isDefault
                                    ? Colors.amber
                                    : blackColor40,
                              ),
                              onPressed: () =>
                                  _setDefault(a.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddressForm(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Address {
  final String id;
  final String label;
  final String details;
  final String city;
  final String phone;
  final bool isDefault;

  _Address({
    required this.id,
    required this.label,
    required this.details,
    required this.city,
    required this.phone,
    required this.isDefault,
  });

  _Address copyWith({
    String? id,
    String? label,
    String? details,
    String? city,
    String? phone,
    bool? isDefault,
  }) {
    return _Address(
      id: id ?? this.id,
      label: label ?? this.label,
      details: details ?? this.details,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'details': details,
      'city': city,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}

class _AddressFormSheet extends StatefulWidget {
  final _Address? existing;

  const _AddressFormSheet({this.existing});

  @override
  State<_AddressFormSheet> createState() =>
      _AddressFormSheetState();
}

class _AddressFormSheetState
    extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _labelController = TextEditingController();
  final _detailsController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    if (a != null) {
      _labelController.text = a.label;
      _detailsController.text = a.details;
      _cityController.text = a.city;
      _phoneController.text = a.phone;
      _isDefault = a.isDefault;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _detailsController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final address = _Address(
      id: widget.existing?.id ?? '',
      label: _labelController.text.trim().isEmpty
          ? 'Address'
          : _labelController.text.trim(),
      details: _detailsController.text.trim(),
      city: _cityController.text.trim(),
      phone: _phoneController.text.trim(),
      isDefault: _isDefault,
    );

    Navigator.of(context).pop(address);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: defaultPadding,
        bottom: bottomPadding + defaultPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existing == null
                        ? 'Add address'
                        : 'Edit address',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Label (Home, Work...)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Address details',
                  hintText:
                      'Street, building, floor...',
                ),
                maxLines: 2,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
                keyboardType: TextInputType.phone,
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
                  'Set as default address',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
