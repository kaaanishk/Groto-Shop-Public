import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: minimumSafeArea,
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('retailers')
              .document(Provider.of<RetailerModel>(context).id)
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ' + snapshot.error.toString()),
              );
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.documents.length == 0) {
              return Center(
                child: Text('No orders yet'),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(),
                      Text('Loading orders'),
                    ],
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.done:
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
              default:
                return Center(child: Text('Something went wrong.'));
            }
          }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final DocumentSnapshot orderSnapshot;

  OrderCard(this.orderSnapshot);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  orderSnapshot.data['userinfo']['name'],
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: ClickableText(
                    onTap: () async {
                      String url =
                          'tel:' + orderSnapshot.data['userinfo']['phone'];
                      try {
                        if (await canLaunch(url)) await launch(url);
                      } catch (e) {
                        throw 'Could not launch $url';
                      }
                    },
                    text: orderSnapshot.data['userinfo']['phone']),
              ),
              if (orderSnapshot.data['shipping_method'] == 'Delivery')
                ListTile(
                  title: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(orderSnapshot.data['userinfo']['address']
                            ['firstline']),
                      ),
                      ListTile(
                        title: Text(orderSnapshot.data['userinfo']['address']
                            ['secondline']),
                      ),
                      ListTile(
                        title: Text(
                            orderSnapshot.data['userinfo']['address']['city']),
                      ),
                    ],
                  ),
                ),
              Divider(color: Colors.black),
              ListView.builder(
                itemCount: orderSnapshot.data['items'].length,
                itemBuilder: (context, index) {
                  String key =
                      orderSnapshot.data['items'].keys.elementAt(index);
                  return ListTile(
                    title: Text(key),
                    trailing: Text(
                      orderSnapshot.data['items'][key].toString(),
                    ),
                  );
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                title: Text('Total:'),
                trailing: Text((orderSnapshot.data['total'] / 100).toString()),
              ),
              Divider(color: Colors.black),
              ListTile(
                title: Text('Payment method:'),
                trailing: Text(orderSnapshot.data['payment']),
              ),
              ListTile(
                title: Text('Shipping method:'),
                trailing: Text(orderSnapshot.data['shipping_method']),
              ),
              orderSnapshot.data['order_status'] == 'created'
                  ? CircularBlackButton(
                      child: Text('Mark as delivered/picked up'),
                      onPressed: () async {
                        await Firestore.instance
                            .collection('orders')
                            .document(orderSnapshot.documentID)
                            .updateData({'order_status': 'delivered'});
                        await Firestore.instance
                            .collection('retailers')
                            .document(orderSnapshot.data['retailer'])
                            .collection('orders')
                            .document(orderSnapshot.documentID)
                            .updateData({'order_status': 'delivered'});
                      },
                    )
                  : ListTile(
                      title: Text('Status:'),
                      trailing: Text('Delivered'),
                    ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.black),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
