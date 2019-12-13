// The most recent file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Retailer {
  String id;
  String image;
  String name;
  String shop;
  double rating;
  int raters;
  String status;
  Map<String, String> address = {'firstline': '', 'secondline': '', 'city': ''};
  String phone;

  Retailer({@required DocumentSnapshot retailerSnapshot}) {
    print(retailerSnapshot.documentID);
    this.id = retailerSnapshot.documentID;
    this.image = retailerSnapshot.data['image'];
    this.name = retailerSnapshot.data['name'];
    this.shop = retailerSnapshot.data['shop'];
    this.phone = retailerSnapshot.data['phone'];
    this.status = retailerSnapshot.data['status'];
    this.address['firstline'] = retailerSnapshot.data['address']['firstline'];
    this.address['secondline'] = retailerSnapshot.data['address']['secondline'];
    this.address['city'] = retailerSnapshot.data['address']['city'];
    this.rating = retailerSnapshot.data['rating'].toDouble();
    this.raters = retailerSnapshot.data['raters'];
  }

  /// Only the Retailer ID is guaranteed to be unique
  bool operator ==(retailer) => retailer is Retailer && retailer.id == id;

  int get hashCode => id.hashCode;
}
