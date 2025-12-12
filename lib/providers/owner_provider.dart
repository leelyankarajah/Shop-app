import 'package:flutter/material.dart';
import 'package:shop/models/product_model.dart';

class OwnerProvider extends ChangeNotifier {
  // قائمة المنتجات اللي ممكن المالك يتحكّم فيها
  final List<ProductModel> _products = List<ProductModel>.from(demoPopularProducts);

  int _visitors = 0;
  int _orders = 0;

  List<ProductModel> get products => List.unmodifiable(_products);
  int get visitors => _visitors;
  int get orders => _orders;

  // إضافة منتج جديد
  void addProduct(ProductModel product) {
    _products.insert(0, product);
    notifyListeners();
  }

  // تعديل منتج موجود
  void updateProduct(String id, ProductModel updated) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = updated;
      notifyListeners();
    }
  }

  // حذف منتج
  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // زيادة عدد الزوّار (ممكن تستدعيها لما يفتح الكستمر الأبلكيشن مثلًا)
  void incrementVisitors() {
    _visitors++;
    notifyListeners();
  }

  // تسجيل طلب (بيزيد عدد الطلبات وعدد الطلبات على المنتج نفسه)
  void addOrder(String productId, {int quantity = 1}) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].ordersCount += quantity;
      _orders += quantity;
      notifyListeners();
    }
  }
}
