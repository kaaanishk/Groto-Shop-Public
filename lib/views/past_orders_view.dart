import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/views/orders_view.dart';
import 'package:provider/provider.dart';

class PastOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Orders'),
        elevation: 0.0,
      ),
      body: SafeArea(
        minimum: minimumSafeArea,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('orders')
              .where('order_status', isEqualTo: 'delivered')
              .where('retailer',
              isEqualTo:
              Provider
                  .of<RetailerModel>(context, listen: false)
                  .id)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong.'),
              );
            } else if (!snapshot.hasData || snapshot.data == null ||
                snapshot.data.documents.length == 0) {
              return Center(
                child: Text('Your old orders will show up here.'),
              );
            }  else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot orderSnapshot =
                  snapshot.data.documents[index];
                  return OrderCard(orderSnapshot);
                },
                shrinkWrap: true,
                physics: ScrollPhysics(),
              );
            }
          },
        ),
      ),
    );
  }
}
