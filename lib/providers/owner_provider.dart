// lib/providers/owner_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shop/models/product_model.dart';

class OwnerProvider extends ChangeNotifier {
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref().child('products');

  final List<ProductModel> _products = [];
  int _visitors = 0;
  int _orders = 0;

  bool _isLoading = false;
  String? _errorMessage;

  StreamSubscription<DatabaseEvent>? _productsSub;

  List<ProductModel> get products => List.unmodifiable(_products);
  int get visitors => _visitors;
  int get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OwnerProvider() {
    _listenToProducts();
  }

  void _listenToProducts() {
    _isLoading = true;
    notifyListeners();

    _productsSub = _productsRef.onValue.listen(
      (event) {
        final data = event.snapshot.value;
        final List<ProductModel> loaded = [];

        if (data is Map<dynamic, dynamic>) {
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              loaded.add(
                ProductModel.fromMap(
                  key.toString(),
                  value,
                ),
              );
            }
          });
        }

        _products
          ..clear()
          ..addAll(loaded);

        _orders =
            _products.fold<int>(0, (sum, p) => sum + p.ordersCount);

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Failed to load products';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    super.dispose();
  }

  Future<void> addProduct(ProductModel product) async {
    await _productsRef.child(product.id).set(product.toMap());
  }

  Future<void> updateProduct(String id, ProductModel updated) async {
    await _productsRef.child(id).update(updated.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productsRef.child(id).remove();
  }

  void incrementVisitors() {
    _visitors++;
    notifyListeners();
    FirebaseDatabase.instance
        .ref()
        .child('stats/visitors')
        .set(_visitors);
  }

  Future<void> addOrder(String productId, {int quantity = 1}) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final product = _products[index];

    product.ordersCount += quantity;
    product.stock = (product.stock - quantity);
    if (product.stock < 0) product.stock = 0;

    _orders += quantity;
    notifyListeners();

    final productRef = _productsRef.child(productId);
    final snap = await productRef.get();
    if (snap.exists && snap.value is Map) {
      final map = Map<dynamic, dynamic>.from(snap.value as Map);

      final int stock =
          (map['stock'] is int) ? map['stock'] as int : int.tryParse(map['stock']?.toString() ?? '0') ?? 0;
      final int ordersCount = (map['ordersCount'] is int)
          ? map['ordersCount'] as int
          : int.tryParse(map['ordersCount']?.toString() ?? '0') ?? 0;

      int newStock = stock - quantity;
      if (newStock < 0) newStock = 0;

      await productRef.update({
        'stock': newStock,
        'ordersCount': ordersCount + quantity,
      });
    }
  }
}