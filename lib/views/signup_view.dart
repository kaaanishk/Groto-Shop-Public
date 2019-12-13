import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groto_shop/enums/view_state.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/strings.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:groto_shop/views/connectivity_view.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storeController = TextEditingController();
  final _firstLineController = TextEditingController();
  final _secondLineController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Sign Up',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                nameField(_nameController),
                _shopField(),
                _phoneField(),
                _firstLineField(),
                _secondLineField(),
                _cityField(),
                emailField(_emailController),
                passwordField(_passwordController),
                VerticalSpace(),
                createAccountButton(context),
              ],
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }

  Widget createAccountButton(BuildContext context) {
    return Consumer<RetailerModel>(
      builder: (context, retailerModel, _) =>
          retailerModel.state == ViewState.BUSY
              ? CupertinoActivityIndicator()
              : CircularBlackButton(
                  child: Text('Create Account'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await retailerModel.createUserWithEmail(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        shop: _storeController.text,
                        firstline: _firstLineController.text,
                        secondline: _secondLineController.text,
                        city: _cityController.text,
                      );
                      try {
                        Navigator.pushReplacementNamed(context, homeView);
                      } catch (e) {
                        showSnackBar(_scaffoldKey, e);
                      }
                    }
                  },
                ),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      autofocus: false,
      controller: _phoneController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Phone (Enter 10 Digit)',
        icon: Icon(
          Icons.phone,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '') {
          return 'Phone cannot be empty';
        } else if (value.length != 10) {
          return 'Invalid phone number';
        } else
          return null;
      },
    );
  }

  Widget _shopField() {
    return TextFormField(
      controller: _storeController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Shop name',
        icon: Icon(
          Icons.store,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Store Name cannot be empty';
        else
          return null;
      },
    );
  }

  Widget _firstLineField() {
    return TextFormField(
      controller: _firstLineController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Flat, House no., Building, Company, Apartment:',
        icon: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'Field cannot be empty';
        else
          return null;
      },
    );
  }

  Widget _secondLineField() {
    return TextFormField(
      controller: _secondLineController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Area, Colony, Street, Sector',
        icon: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'Field cannot be empty';
        else
          return null;
      },
    );
  }

  Widget _cityField() {
    return TextFormField(
      controller: _cityController,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'City',
        icon: Icon(
          Icons.location_city,
          color: Colors.black,
        ),
      ),
      validator: (value) {
        if (value.isEmpty || value == '')
          return 'City cannot be empty';
        else
          return null;
      },
    );
  }
}
