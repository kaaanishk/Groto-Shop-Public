import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/enums/view_state.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/strings.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(8.0),
      child: Consumer<RetailerModel>(builder: (context, retailerModel, _) {
        return Column(
          children: <Widget>[
            _profile(retailerModel),
            retailerModel.state == ViewState.BUSY
                ? CupertinoActivityIndicator()
                : Column(
                    children: <Widget>[
                      _shopStatusButton(retailerModel),
                      _logoutButton(context, retailerModel),
                    ],
                  )
          ],
        );
      }),
    );
  }

  Widget _profile(RetailerModel retailerModel) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                retailerModel.shop,
                textScaleFactor: 1.5,
              ),
              Text(
                retailerModel.name,
              ),
              VerticalSpace(),
              Text(
                retailerModel.firstline,
              ),
              Text(
                retailerModel.secondline,
              ),
              Text(
                retailerModel.city,
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black),
          ),
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _address(RetailerModel retailerModel) {
    return Column(
      children: <Widget>[
        Text(
          retailerModel.firstline,
        ),
        Text(
          retailerModel.secondline,
        ),
        Text(
          retailerModel.city,
        ),
      ],
    );
  }

  Widget _rating(RetailerModel retailerModel) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Container(
        color: Colors.green[400],
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Text(
              'Rating:',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              retailerModel.rating.toString(),
              textScaleFactor: 3,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pastOrder(BuildContext context) {
    return CircularBlackButton(
      child: Text(
        'Past Orders',
      ),
      onPressed: () {
        Navigator.pushNamed(context, pastOrdersView);
      },
    );
  }

  Widget _shopStatusButton(RetailerModel retailerModel) {
    return MaterialButton(
      elevation: 2.0,
      color: (retailerModel.status == 'open')
          ? Colors.red[300]
          : Colors.green[300],
      minWidth: double.infinity,
      child: Text(
          (retailerModel.status == 'open')
              ? 'Stop Taking Orders'
              : 'Start Taking Orders',
          style: TextStyle(color: Colors.white)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      onPressed: () async {
        await retailerModel.changeShopState();
      },
    );
  }

  Widget _logoutButton(BuildContext context, RetailerModel retailerModel) {
    return CircularBlackButton(
      child: Text('Log Out'),
      onPressed: () async {
        await retailerModel.logOut();
        Navigator.pushReplacementNamed(context, loginView);
      },
    );
  }
}
