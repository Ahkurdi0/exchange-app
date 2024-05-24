import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:exchnage_app/models/BranchModel.dart';
import 'package:flutter/material.dart';

@immutable
class TransactionModel extends Equatable {
  final String? uId;
  final BranchModel? fromBranch;
  final BranchModel? toBranch;
  final double? sendingAmount;
  final double? receivingAmount;
  final double? totalCommission;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final String? transactionDocumentUrl;
  final String? toPhone;

  const TransactionModel({
    this.uId,
    this.fromBranch,
    this.toBranch,
    this.sendingAmount,
    this.receivingAmount,
    this.totalCommission,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.transactionDocumentUrl,
    this.toPhone,
  });

  TransactionModel copyWith({
    String? uId,
    BranchModel? fromBranch,
    BranchModel? toBranch,
    double? sendingAmount,
    double? receivingAmount,
    double? totalCommission,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? transactionDocumentUrl,
    String? toPhone,
  }) {
    return TransactionModel(
      uId: uId ?? this.uId,
      fromBranch: fromBranch ?? this.fromBranch,
      toBranch: toBranch ?? this.toBranch,
      sendingAmount: sendingAmount ?? this.sendingAmount,
      receivingAmount: receivingAmount ?? this.receivingAmount,
      totalCommission: totalCommission ?? this.totalCommission,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      transactionDocumentUrl:
          transactionDocumentUrl ?? this.transactionDocumentUrl,
      toPhone: toPhone ?? this.toPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'fromBranch': fromBranch?.toMap(),
      'toBranch': toBranch?.toMap(),
      'sendingAmount': sendingAmount,
      'receivingAmount': receivingAmount,
      'totalCommission': totalCommission,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'status': status,
      'transactionDocumentUrl': transactionDocumentUrl,
      'toPhone': toPhone,
    };
  }

  factory TransactionModel.fromSnap(DocumentSnapshot snapshot) {
    return TransactionModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      uId: map['uId'],
      fromBranch: map['fromBranch'] != null
          ? BranchModel.fromMap(map['fromBranch'] as Map<String, dynamic>)
          : null,
      toBranch: map['toBranch'] != null
          ? BranchModel.fromMap(map['toBranch'] as Map<String, dynamic>)
          : null,
      sendingAmount: map['sendingAmount'] as double?,
      receivingAmount: map['receivingAmount'] as double?,
      totalCommission: map['totalCommission'] as double?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      status: map['status'] as String?,
      transactionDocumentUrl: map['transactionDocumentUrl'] as String?,
      toPhone: map['toPhone'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        uId,
        fromBranch,
        toBranch,
        sendingAmount,
        receivingAmount,
        totalCommission,
        createdAt,
        updatedAt,
        status,
        transactionDocumentUrl,
        toPhone,
      ];

  @override
  bool get stringify => true;
}
