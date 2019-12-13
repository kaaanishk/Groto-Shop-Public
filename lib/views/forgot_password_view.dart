import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groto_shop/enums/view_state.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/shared/constants.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:groto_shop/views/connectivity_view.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Enter your email'),
                emailField(_emailController),
                VerticalSpace(),
                Consumer<RetailerModel>(
                  builder: (context, retailerModel, _) =>
                      (retailerModel.state == ViewState.BUSY)
                          ? CupertinoActivityIndicator()
                          : StretchedCircularBlackButton(
                              child: Text('Reset Password'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    await retailerModel.resetPassword(
                                        email: _emailController.text);
                                    showSnackBar(_scaffoldKey,
                                        'A password reset link has been sent to your email.');
                                  } catch (e) {
                                    showSnackBar(_scaffoldKey, e.toString());
                                  }
                                }
                              },
                            ),
                )
              ],
            ),
            key: _formKey,
          ),
          minimum: minimumSafeArea,
        ),
        key: _scaffoldKey,
      ),
    );
  }
}
