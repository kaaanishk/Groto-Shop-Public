import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/services/database_service.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/shared/item.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:groto_shop/views/connectivity_view.dart';

class UpdateItemView extends StatefulWidget {
  Item item;
  RetailerModel retailerModel;

  TextEditingController _nameController;

  TextEditingController _priceController;

  TextEditingController _mrpController;

  TextEditingController _quantityController;

  TextEditingController _weightController;

  @override
  _UpdateItemViewState createState() => _UpdateItemViewState();

  UpdateItemView({@required this.item, this.retailerModel}) {
    _nameController = TextEditingController(text: item.name);
    _mrpController = TextEditingController(text: (item.mrp / 100).toString());
    _priceController =
        TextEditingController(text: (item.price / 100).toString());
    _quantityController = TextEditingController(text: item.quantity.toString());
    _weightController = TextEditingController(text: item.weight.toString());
  }
}

class _UpdateItemViewState extends State<UpdateItemView> {
  final _formKey = GlobalKey<FormState>();
  Database _database = Database();

  Widget nameField() {
    return TextFormField(
        controller: widget._nameController,
        enabled: false,
        decoration: InputDecoration(prefixText: 'Name: '));
  }

  Widget weightField() {
    return TextFormField(
        controller: widget._weightController,
        enabled: false,
        decoration: InputDecoration(prefixText: 'Weight (g): '));
  }

  Widget mrpField() {
    return TextFormField(
      controller: widget._mrpController,
      enabled: false,
      decoration: InputDecoration(prefixText: 'MRP: '),
    );
  }

  Widget priceField() {
    return TextFormField(
      controller: widget._priceController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration:
          InputDecoration(hintText: 'Your Price', prefixText: 'Price: '),
      validator: (value) {
        if (value.isEmpty)
          return 'Price cannot be empty';
        else
          return null;
      },
    );
  }

  Widget quantityField() {
    return TextFormField(
      controller: widget._quantityController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration:
          InputDecoration(hintText: 'Quantity', prefixText: 'Quantity: '),
      validator: (value) {
        if (value.isEmpty)
          return 'Quantity cannot be empty';
        else
          return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Item Info',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
          ),
        )),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SafeArea(
          minimum: minimumSafeArea,
          child: Form(
            child: ListView(
              children: <Widget>[
                nameField(),
                weightField(),
                mrpField(),
                priceField(),
                quantityField(),
                VerticalSpace(),
                CircularBlackButton(
                  child: Text(
                    'Update Item',
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _database.updateItemPriceAndQuantity(
                          item: widget.item,
                          retailerId: widget.retailerModel.id,
                          price: double.parse(widget._priceController.text),
                          quantity: int.parse(widget._quantityController.text));
                      Navigator.pop(context);
                    }
                  },
                )
              ],
              shrinkWrap: true,
            ),
            key: _formKey,
          ),
        ),
      ),
    );
  }
}
