import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  // قائمة المنتجات بالكارت
  final List<Map<String, dynamic>> _items = [];

  // استرجاع المنتجات
  List<Map<String, dynamic>> get items => _items;

  // حساب السعر الكلي
  double get totalPrice => _items.fold(
        0,
        (sum, item) => sum + (item['price'] ?? 0) * (item['qty'] ?? 1),
      );

  // إضافة منتج للكارت
  void addProduct(Map<String, dynamic> product) {
    // التحقق إذا المنتج موجود مسبقاً
    final index = _items.indexWhere((p) => p['id'] == product['id']);
    if (index >= 0) {
      // إذا موجود، زود الكمية
      _items[index]['qty'] = (_items[index]['qty'] ?? 1) + 1;
    } else {
      // إذا جديد، أضف المنتج مع qty = 1
      product['qty'] = 1;
      _items.add(product);
    }
    notifyListeners(); // مهم جداً لتحديث الكارت مباشرة
  }

  // إزالة منتج بالكامل
  void removeProduct(String id) {
    _items.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  // تعديل كمية منتج معين
  void updateQty(String id, int qty) {
    final index = _items.indexWhere((p) => p['id'] == id);
    if (index >= 0) {
      if (qty <= 0) {
        removeProduct(id); // إذا الكمية 0 أو أقل، ازل المنتج
      } else {
        _items[index]['qty'] = qty;
        notifyListeners();
      }
    }
  }

  // مسح كل المنتجات
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
