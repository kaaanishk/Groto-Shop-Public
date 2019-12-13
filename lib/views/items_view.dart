//import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/shared/item.dart';
import 'package:groto_shop/shared/strings.dart';
import 'package:groto_shop/views/update_item_view.dart';
import 'package:provider/provider.dart';

class ItemsView extends StatefulWidget {
  @override
  _ItemsViewState createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  final _ItemSearchDelegate _delegate = _ItemSearchDelegate();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _lastItemSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: minimumSafeArea,
        child: Consumer<RetailerModel>(builder: (context, retailerModel, _) {
          return Column(
            children: <Widget>[
              _addCustomItem(context, retailerModel),
              _divider(),
              _itemList(context, retailerModel),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          final String selected = await showSearch<String>(
            context: context,
            delegate: _delegate,
          );
          if (selected != null && selected != _lastItemSelected) {
            setState(() {
              _lastItemSelected = selected;
            });
          }
        },
      ),
      key: _scaffoldKey,
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.black,
    );
  }

  Widget _addCustomItem(BuildContext context, RetailerModel retailerModel) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text(
            'Add custom item',
            textAlign: TextAlign.center,
          ),
          onTap: () async {
            // TODO: Open Camera Properly
            Navigator.pushNamed(context, addCustomItemView);
          },
        ),
      ],
    );
  }

  Widget _itemList(BuildContext context, RetailerModel retailerModel) {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('retailers')
            .document(retailerModel.id)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Loading Items')
                ]);
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
                Item item = Item(itemSnapshot: itemSnapshot);
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Rs. ' +
                      (item.price / 100).toString() +
                      ' per ' +
                      item.weight.toString() +
                      ' gm'),
                  trailing: addToStore(
                      context: context,
                      item: item,
                      retailerModel: retailerModel),
                );
              },
              shrinkWrap: true,
              physics: ScrollPhysics(),
            );
          }
        },
      ),
    );
  }
}

class _ItemSearchDelegate extends SearchDelegate<String> {
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.black,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    RetailerModel _retailerModel = Provider.of<RetailerModel>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('retailers')
          .document(_retailerModel.id)
          .collection('items')
          .orderBy('name')
          .where('name',
              isGreaterThanOrEqualTo: query.length == 0
                  ? query
                  : query[0].toUpperCase() + query.substring(1).toLowerCase())
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Loading suggestions')
                ]),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
              Item item = Item(itemSnapshot: itemSnapshot);
              return ListTile(
                title: Text(
                  item.name,
                ),
                trailing: addToStore(
                    context: context,
                    retailerModel: _retailerModel,
                    item: item),
              );
            },
            shrinkWrap: true,
            physics: ScrollPhysics(),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    RetailerModel _retailerModel = Provider.of<RetailerModel>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('retailers')
          .document(_retailerModel.id)
          .collection('items')
          .orderBy('name')
          .where('name',
              isGreaterThanOrEqualTo: query.length == 0
                  ? query
                  : query[0].toUpperCase() + query.substring(1).toLowerCase())
          .limit(25)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text('Searching for your item')
                ]),
          );
        } else if (snapshot.data.documents.length == 0) {
          return Center(
              child: Text('The item you are looking for is not available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot itemSnapshot = snapshot.data.documents[index];
              Item item = Item(itemSnapshot: itemSnapshot);
              return ListTile(
                title: Text(
                  item.name,
                ),
                trailing: addToStore(
                    context: context,
                    retailerModel: _retailerModel,
                    item: item),
              );
            },
            shrinkWrap: true,
            physics: ScrollPhysics(),
          );
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Text('')
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }
}

Widget addToStore(
    {@required BuildContext context, Item item, RetailerModel retailerModel}) {
  return MaterialButton(
      color: Colors.black,
      child: Text(
        item.quantity == 0 ? 'Add to store' : 'Update',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UpdateItemView(item: item, retailerModel: retailerModel)));
      });
}
