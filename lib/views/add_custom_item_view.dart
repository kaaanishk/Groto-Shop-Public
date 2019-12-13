import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/services/database_service.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:provider/provider.dart';

class AddCustomItemView extends StatefulWidget {
  @override
  _AddCustomItemViewState createState() => _AddCustomItemViewState();
}

class _AddCustomItemViewState extends State<AddCustomItemView> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  TextEditingController _mrpController = TextEditingController();

  TextEditingController _quantityController = TextEditingController();

  TextEditingController _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Database _database = Database();

  Widget nameField() {
    return TextFormField(
      controller: _nameController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Name cannot be empty';
        else
          return null;
      },
    );
  }

  Widget mrpField() {
    return TextFormField(
      controller: _mrpController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Maximum Retail Price',
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Marked Price cannot be empty';
        else
          return null;
      },
    );
  }

  Widget priceField() {
    return TextFormField(
      controller: _priceController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Your Price',
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Price cannot be empty';
        else
          return null;
      },
    );
  }

  Widget weightField() {
    return TextFormField(
      controller: _weightController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Weight (gm)',
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Weight cannot be empty';
        else
          return null;
      },
    );
  }

  Widget quantityField() {
    return TextFormField(
      controller: _quantityController,
      maxLines: 1,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(hintText: 'Quantity'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add custom item',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        minimum: minimumSafeArea,
        child: Form(
          child: ListView(
            children: <Widget>[
              VerticalSpace(),
              nameField(),
              weightField(),
              mrpField(),
              priceField(),
              quantityField(),
              VerticalSpace(),
              CircularBlackButton(
                child: Text(
                  'Upload Item',
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _database.addItem(
                        name: _nameController.text,
                        retailerId:
                            Provider.of<RetailerModel>(context, listen: false)
                                .id,
                        price: double.parse(_priceController.text),
                        mrp: double.parse(_mrpController.text),
                        weight: int.parse(_weightController.text),
                        quantity: int.parse(_quantityController.text));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
          key: _formKey,
        ),
      ),
    );
  }
}
