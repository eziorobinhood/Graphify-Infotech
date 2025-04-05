// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Invoice {
  final String id;
  final String invoice_number;
  final String recipient_name;
  final String phone_number;
  final String address;
  final String tabledata;
  final String addata;
  final String totalamount;
  final String advance_paid;
  final String balance_amount;
  Invoice({
    required this.id,
    required this.invoice_number,
    required this.recipient_name,
    required this.phone_number,
    required this.tabledata,
    required this.addata,
    required this.address,
    required this.totalamount,
    required this.advance_paid,
    required this.balance_amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'invoice_number': invoice_number,
      'recipient_name': recipient_name,
      'phone_number': phone_number,
      'codelist': tabledata,
      'adlist': addata,
      'address': address,
      'totalamount': totalamount,
      'advance_paid': advance_paid,
      'balance_amount': balance_amount,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['_id'] as String,
      invoice_number: map['invoice_number'] as String,
      recipient_name: map['recipient_name'] as String,
      phone_number: map['phone_number'] as String,
      address: map['address'] as String,
      tabledata: map['codelist'] as String,
      addata: map['adlist'] as String,
      totalamount: map['totalamount'] as String,
      advance_paid: map['advance_paid'] as String,
      balance_amount: map['balance_amount'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);
}
