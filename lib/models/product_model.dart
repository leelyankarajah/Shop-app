// lib/models/product_model.dart
import 'package:flutter/foundation.dart';

class ProductModel {
  final String id;
  final String image;
  final String brandName;
  final String title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  int stock;
  bool available;
  int ordersCount;

  ProductModel({
    required this.id,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.stock = 0,
    this.available = true,
    this.ordersCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'brandName': brandName,
      'title': title,
      'price': price,
      'priceAfetDiscount': priceAfetDiscount,
      'dicountpercent': dicountpercent,
      'stock': stock,
      'available': available,
      'ordersCount': ordersCount,
    };
  }

  factory ProductModel.fromMap(String id, Map<dynamic, dynamic> map) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProductModel(
      id: id,
      image: map['image']?.toString() ?? '',
      brandName: map['brandName']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      price: _toDouble(map['price']) ?? 0.0,
      priceAfetDiscount: _toDouble(map['priceAfetDiscount']),
      dicountpercent:
          map['dicountpercent'] == null ? null : _toInt(map['dicountpercent']),
      stock: _toInt(map['stock']),
      available: map['available'] as bool? ?? true,
      ordersCount: _toInt(map['ordersCount']),
    );
  }

  ProductModel copyWith({
    String? id,
    String? image,
    String? brandName,
    String? title,
    double? price,
    double? priceAfetDiscount,
    int? dicountpercent,
    int? stock,
    bool? available,
    int? ordersCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      image: image ?? this.image,
      brandName: brandName ?? this.brandName,
      title: title ?? this.title,
      price: price ?? this.price,
      priceAfetDiscount: priceAfetDiscount ?? this.priceAfetDiscount,
      dicountpercent: dicountpercent ?? this.dicountpercent,
      stock: stock ?? this.stock,
      available: available ?? this.available,
      ordersCount: ordersCount ?? this.ordersCount,
    );
  }
}
