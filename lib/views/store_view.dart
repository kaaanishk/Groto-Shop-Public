import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/item.dart';
import 'package:provider/provider.dart';

class StoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Consumer<RetailerModel>(
            builder: (context, retailerModel, _) {
              return StreamBuilder(
                stream: Firestore.instance
                    .collection('retailers')
                    .document(retailerModel.id)
                    .collection('items')
                    .where('quantity', isGreaterThan: 0)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CupertinoActivityIndicator(),
                          Text('Loading Items'),
                        ],
                      ),
                    );
                  } else if (snapshot.data.documents.length == 0) {
                    return Expanded(
                      child: Center(
                        child: Text('Your store is empty'),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot itemSnapshot =
                            snapshot.data.documents[index];
                        Item item = Item(itemSnapshot: itemSnapshot);
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            'Rs. ' +
                                (item.price / 100).toString() +
                                ' per ' +
                                item.weight.toString() +
                                ' gm',
                          ),
                          trailing: Text(
                            item.quantity.toString(),
                          ),
                        );
                      },
                      shrinkWrap: true,
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: 2, childAspectRatio: 0.6),
                      physics: ScrollPhysics(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
