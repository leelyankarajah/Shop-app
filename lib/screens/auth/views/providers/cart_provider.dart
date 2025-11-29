import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + (item['price'] * (item['qty'] ?? 1)));

  void addProduct(Map<String, dynamic> product) {
    // إذا المنتج موجود، نزود الكمية
    final index = _items.indexWhere((p) => p['id'] == product['id']);
    if (index != -1) {
      _items[index]['qty'] = (_items[index]['qty'] ?? 1) + 1;
    } else {
      final newProduct = Map<String, dynamic>.from(product);
      newProduct['qty'] = 1;
      _items.add(newProduct);
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  void restoreProduct(Map<String, dynamic> product) {
    _items.add(product);
    notifyListeners();
  }

  void updateQty(String id, int qty) {
    final index = _items.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      _items[index]['qty'] = qty;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
