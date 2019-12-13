import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/enums/view_state.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/strings.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:groto_shop/views/connectivity_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Widget buttons(BuildContext context) {
    return Consumer<RetailerModel>(
      builder: (context, model, _) => model.state == ViewState.BUSY
          ? CupertinoActivityIndicator()
          : Column(
              children: <Widget>[
                logInButton(context, model),
                signUpButton(context),
                VerticalSpace(),
                ClickableText(
                  text: 'Forgot your password?',
                  onTap: () {
                    Navigator.pushNamed(context, forgotPasswordView);
                  },
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: title(),
                  flex: 1,
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      emailField(_emailController),
                      passwordField(_passwordController),
                      VerticalSpace(),
                      buttons(context),
                    ],
                  ),
                  flex: 2,
                ),
              ],
            ),
            key: _formKey,
          ),
          minimum: EdgeInsets.all(12.0),
        ),
        key: _scaffoldKey,
      ),
    );
  }

  Widget logInButton(BuildContext context, RetailerModel retailerModel) {
    return CircularBlackButton(
        child: Text('Log In'),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            try {
              await retailerModel.logInEmail(
                _emailController.text,
                _passwordController.text,
              );
              Navigator.pushReplacementNamed(context, homeView);
            } catch (e) {
              showSnackBar(_scaffoldKey, e);
            }
          }
        });
  }

  Widget signUpButton(BuildContext context) {
    return CircularBlackButton(
      child: Text('Sign Up'),
      onPressed: () {
        Navigator.pushNamed(context, signupView);
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
