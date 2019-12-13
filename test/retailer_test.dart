import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groto_shop/shared/retailer.dart';
import 'package:mockito/mockito.dart';

class RetailerDocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  RetailerDocumentSnapshotMock(this.documentID, this.data);
}

void main() {
  group('Retailer', () {
    test('Test whether retailer data is parsed correctly', () {
      Map<String, dynamic> data = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
      };
      var retailerSnapshot = RetailerDocumentSnapshotMock('QVSePFSs9Ln', data);
      Retailer retailer = Retailer(retailerSnapshot: retailerSnapshot);
      expect(retailer.id, 'QVSePFSs9Ln');
      expect(retailer.image, 'https://via.placeholder.com/150');
      expect(retailer.name, 'Person A');
      expect(retailer.shop, 'Shop X');
      expect(retailer.phone, '1234567890');
      expect(
          retailer.address, {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'});
      expect(retailer.address['firstline'], 'X');
      expect(retailer.address['secondline'], 'Y');
      expect(retailer.address['city'], 'Z');
      expect(retailer.rating, 4.5);
      expect(retailer.raters, 30);
    });

    test('Check whether retailers are the same', () {
      Map<String, dynamic> data1 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
      };
      Map<String, dynamic> data2 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person B',
        'shop': 'Shop Y',
        'phone': '1234567890',
        'status': 'created',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
      };

      var retailerSnapshot1 = RetailerDocumentSnapshotMock('QVSePFSs9', data1);
      var retailerSnapshot2 = RetailerDocumentSnapshotMock('QVSePFSs9', data2);
      Retailer retailer1 = Retailer(retailerSnapshot: retailerSnapshot1);
      Retailer retailer2 = Retailer(retailerSnapshot: retailerSnapshot2);
      expect(retailer1 == retailer2, true);
    });

    test('Check whether retailers are not the same', () {
      Map<String, dynamic> data1 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'open',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
      };
      Map<String, dynamic> data2 = {
        'image': 'https://via.placeholder.com/150',
        'name': 'Person A',
        'shop': 'Shop X',
        'phone': '1234567890',
        'status': 'created',
        'address': {'firstline': 'X', 'secondline': 'Y', 'city': 'Z'},
        'rating': 4.5,
        'raters': 30,
      };;

      var retailerSnapshot1 = RetailerDocumentSnapshotMock('QVSePFSs9', data1);
      var retailerSnapshot2 = RetailerDocumentSnapshotMock('QVSePFSsX', data2);

      Retailer retailer1 = Retailer(retailerSnapshot: retailerSnapshot1);
      Retailer retailer2 = Retailer(retailerSnapshot: retailerSnapshot2);
      expect(retailer1 == retailer2, false);
    });
  });
}
