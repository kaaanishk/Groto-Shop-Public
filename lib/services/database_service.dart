import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:groto_shop/shared/item.dart';
import 'package:groto_shop/shared/retailer.dart';

class Database {
  Firestore _firestore = Firestore.instance;
  CollectionReference _retailers;
  CollectionReference _items;

  Database() {
    _retailers = _firestore.collection('retailers');
    _items = _firestore.collection('items');
  }

  Future<void> updateRetailerPhoneOnDatabase(
      {@required String id, String phone}) async {
    try {
      await _retailers.document(id).updateData({'phone': phone});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateRetailerAddressOnDatabase(
      {@required String id, Map<String, String> address}) async {
    try {
      await _retailers.document(id).updateData({'address': address});
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserDataOnDatabase(
      {@required String id, Map<String, dynamic> data}) async {
    try {
      await updateRetailerPhoneOnDatabase(id: id, phone: data['phone']);
      await updateRetailerAddressOnDatabase(id: id, address: data['address']);
    } catch (e) {
      throw e;
    }
  }

  Future<Retailer> fetchFromDatabase({@required String id}) async {
    try {
      DocumentSnapshot retailerSnapshot = await _retailers.document(id).get();
      return Retailer(retailerSnapshot: retailerSnapshot);
    } catch (e) {
      throw e;
    }
  }

  Future<void> createProfile({
    @required String id,
    @required String name,
    @required String email,
    @required String phone,
    @required String shop,
    @required String firstline,
    @required String secondline,
    @required String city,
  }) async {
    try {
      await _retailers.document(id).setData({
        'name': name,
        'email': email,
        'address': {
          'firstline': firstline,
          'secondline': secondline,
          'city': city,
        },
        'phone': phone,
        'shop': shop,
        'rating': 5,
        'raters': 1,
        'point': {'geopoint': null, 'geohash': ''}, // TODO: Implement location api
      });

      _items.snapshots().listen((snapshot) {
        List<DocumentSnapshot> documents = snapshot.documents;
        for (var document in documents) {
          _retailers
              .document(id)
              .collection('items')
              .document(document.documentID)
              .setData(document.data);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addItem({
    @required String retailerId,
    @required String name,
    @required double mrp,
    @required int weight,
    @required double price,
    @required int quantity,
  }) async {
    try {
      await _retailers
          .document(retailerId)
          .collection('items')
          .document()
          .setData({
        'name': name,
        'price': (price * 100).toInt(),
        'quantity': quantity,
        'mrp': (mrp * 100).toInt(),
        'weight': weight
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateItemPriceAndQuantity(
      {@required String retailerId,
      @required Item item,
      @required double price,
      @required int quantity}) async {
    try {
      await _retailers
          .document(retailerId)
          .collection('items')
          .document(item.id)
          .updateData({'price': (price * 100).toInt(), 'quantity': quantity});
    } catch (e) {
      throw e;
    }
  }

  Future<void> changeStatus(String retailerId, String status) async {
    try {
      await _retailers
          .document(retailerId)
          .updateData({'status': (status == 'open') ? 'closed' : 'open'});
    } catch (e) {
      throw e;
    }
  }
}
