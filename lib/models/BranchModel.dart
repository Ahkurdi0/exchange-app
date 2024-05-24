import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class BranchModel extends Equatable {
  final String? uId;
  final String? branchName;
  final String? iconUrl;
  final String? qrCodeUrl;
  final String? qrCodeValue;
  final String? phoneNumber;
  final String? api;
  final num? commissionAmount;
  final bool? hasApi;
  final String? currency;

  const BranchModel({
    this.uId,
    this.branchName,
    this.iconUrl,
    this.qrCodeUrl,
    this.qrCodeValue,
    this.phoneNumber,
    this.api,
    this.commissionAmount,
    this.hasApi,
    this.currency,
  });

  BranchModel copyWith({
    String? uId,
    String? branchName,
    String? iconUrl,
    String? qrCodeUrl,
    String? qrCodeValue,
    String? phoneNumber,
    String? api,
    num? commissionAmount,
    bool? hasApi,
    String? currency,
  }) {
    return BranchModel(
      uId: uId ?? this.uId,
      branchName: branchName ?? this.branchName,
      iconUrl: iconUrl ?? this.iconUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      qrCodeValue: qrCodeValue ?? this.qrCodeValue,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      api: api ?? this.api,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      hasApi: hasApi ?? this.hasApi,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'branchName': branchName,
      'iconUrl': iconUrl,
      'qrCodeUrl': qrCodeUrl,
      'qrCodeValue': qrCodeValue,
      'phoneNumber': phoneNumber,
      'api': api,
      'commissionAmount': commissionAmount,
      'hasApi': hasApi,
      'currency': currency,
    };
  }

  factory BranchModel.fromSnap(DocumentSnapshot snapshot) {
    return BranchModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      uId: map['uId'],
      branchName: map['branchName'],
      iconUrl: map['iconUrl'],
      qrCodeUrl: map['qrCodeUrl'],
      qrCodeValue: map['qrCodeValue'],
      phoneNumber: map['phoneNumber'],
      api: map['api'],
      commissionAmount: map['commissionAmount'],
      hasApi: map['hasApi'] as bool?,
      currency: map['currency'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchModel.fromJson(String source) =>
      BranchModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        uId,
        branchName,
        iconUrl,
        qrCodeUrl,
        qrCodeValue,
        phoneNumber,
        api,
        commissionAmount,
        hasApi,
        currency,
      ];

  @override
  bool get stringify => true;
}
