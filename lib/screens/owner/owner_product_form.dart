// lib/screens/auth/views/owner_product_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/owner_provider.dart';

class OwnerProductForm extends StatefulWidget {
  /// لو مش null → Edit
  /// لو null → Add جديد
  final ProductModel? existingProduct;

  const OwnerProductForm({super.key, this.existingProduct});

  @override
  State<OwnerProductForm> createState() => _OwnerProductFormState();
}

class _OwnerProductFormState extends State<OwnerProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _discountPercentController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isSaving = false;

  bool get _isEdit => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();

    // لو Edit → عبّي البيانات القديمة في الفورم
    final p = widget.existingProduct;
    if (p != null) {
      _titleController.text = p.title;
      _brandController.text = p.brandName;
      _priceController.text = p.price.toString();
      if (p.priceAfetDiscount != null) {
        _discountPriceController.text = p.priceAfetDiscount!.toString();
      }
      if (p.dicountpercent != null) {
        _discountPercentController.text = p.dicountpercent!.toString();
      }
      _stockController.text = p.stock.toString();
      _imageController.text = p.image;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _discountPercentController.dispose();
    _stockController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final double price = double.parse(_priceController.text.trim());
      final double? discountPrice =
          _discountPriceController.text.trim().isEmpty
              ? null
              : double.tryParse(_discountPriceController.text.trim());

      final int? discountPercent =
          _discountPercentController.text.trim().isEmpty
              ? null
              : int.tryParse(_discountPercentController.text.trim());

      final int stock = int.tryParse(_stockController.text.trim()) ?? 0;

      final owner = context.read<OwnerProvider>();

      if (_isEdit) {
        // ------------ Edit -------------
        final old = widget.existingProduct!;

        final updated = old.copyWith(
          title: _titleController.text.trim(),
          brandName: _brandController.text.trim(),
          price: price,
          priceAfetDiscount: discountPrice,
          dicountpercent: discountPercent,
          stock: stock,
          available: stock > 0,
          image: _imageController.text.trim(),
        );

        await owner.updateProduct(old.id, updated);
      } else {
        // ------------ Add -------------
        final String id =
            DateTime.now().millisecondsSinceEpoch.toString();

        final product = ProductModel(
          id: id,
          image: _imageController.text.trim(),
          brandName: _brandController.text.trim(),
          title: _titleController.text.trim(),
          price: price,
          priceAfetDiscount: discountPrice,
          dicountpercent: discountPercent,
          stock: stock,
          available: stock > 0,
        );

        await owner.addProduct(product);
      }

      if (mounted) {
        Navigator.of(context).pop(); // ارجع من الصفحة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEdit
                  ? 'Product updated successfully'
                  : 'Product added successfully',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          _isEdit ? 'Edit product' : 'Add product',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Product title',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: 'Brand name',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (₪)',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }
                      final p = double.tryParse(v.trim());
                      if (p == null || p <= 0) {
                        return 'Enter valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _discountPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Price after discount (optional)',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _discountPercentController,
                    decoration: const InputDecoration(
                      labelText: 'Discount % (optional)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock quantity',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Required';
                      }
                      final s = int.tryParse(v.trim());
                      if (s == null || s < 0) {
                        return 'Enter valid stock';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProduct,
                      child: _isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEdit ? 'Update product' : 'Save product'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
