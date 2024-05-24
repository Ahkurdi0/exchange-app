import 'package:flutter/material.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExchangeCategories = [
    {
      "name": 'AsiaPay',
      "image": 'assets/icons/asiapay.png',
      'qrcode': 'assets/qr/fib_qr.png',
    },
    {
      "name": 'ZainCash',
      "image": 'assets/icons/zaincash.png',
      'qrcode': 'assets/qr/fib_qr.png',
    },
    {
      "name": 'Fib',
      'image': 'assets/icons/fib.png',
      'qrcode': 'assets/icons/fib.png',
    },
    {
      "name": 'FastPay',
      'image': 'assets/icons/fastpay.png',
      'qrcode': 'assets/qr/fib_qr.png',
    },
    {
      "name": 'Cash',
      'image': 'assets/icons/cash.png',
      'qrcode': 'assets/qr/fib_qr.png',
    },
  ];

  String getExchangeCategoryImage(String categoryName) {
    final category = homeExchangeCategories.firstWhere(
      (category) => category['name'] == categoryName,
      orElse: () => {'image': 'assets/images/default.png'},
    );
    return category['image'] as String;
  }
}
