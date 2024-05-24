import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ExchangeRate extends Equatable {
  final String? uId;
  final String? fromCurrency;
  final String? toCurrency;
  final double? rate;

  const ExchangeRate({
    this.uId,
    this.fromCurrency,
    this.toCurrency,
    this.rate,
  });

  ExchangeRate copyWith({
    String? uId,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
  }) {
    return ExchangeRate(
      uId: uId ?? this.uId,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'rate': rate,
    };
  }

  factory ExchangeRate.fromSnap(DocumentSnapshot snapshot) {
    return ExchangeRate.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  factory ExchangeRate.fromMap(Map<String, dynamic> map) {
    return ExchangeRate(
      uId: map['uId'],
      fromCurrency: map['fromCurrency'],
      toCurrency: map['toCurrency'],
      rate: map['rate'] as double?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExchangeRate.fromJson(String source) =>
      ExchangeRate.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        uId,
        fromCurrency,
        toCurrency,
        rate,
      ];

  @override
  bool get stringify => true;
}
