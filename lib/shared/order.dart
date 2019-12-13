import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order {
  String id;
  int amount;
  String currency;
  String status;
  int created_at;
  Map<String, dynamic> items;
  String customer_name;
  String customer_phone;
  double distance;

  Order({@required DocumentSnapshot orderSnapshot}) {
    this.id = orderSnapshot.documentID;
    this.amount = orderSnapshot.data['amount'];
    this.status = orderSnapshot.data['status'];
    this.created_at = orderSnapshot.data['created_at'];
    this.items = orderSnapshot.data['items'];
    this.customer_name = orderSnapshot.data['customer_name'];
    this.customer_phone = orderSnapshot.data['customer_phone'];
    this.distance = orderSnapshot.data['distance'].toDouble();
  }
}
