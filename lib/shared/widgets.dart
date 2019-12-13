import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'item.dart';

Widget scaffoldTitle() {
  return Text(
    'Groto Shop',
    style: TextStyle(
      fontFamily: 'NotoSerif',
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget itemCard(BuildContext context, Item item) {
  return Column(
    children: <Widget>[
      Text(
        item.name,
        textScaleFactor: 1.3,
      ),
      Text('Rs. ' +
          (item.price / 100).toString() +
          ' per ' +
          item.weight.toString() +
          ' gm'),
    ],
  );
}

bool emailInvalidRegex(String email) {
  String p =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  RegExp expression = RegExp(p);
  return !expression.hasMatch(email);
}

Widget emailField(TextEditingController emailController) {
  return TextFormField(
    controller: emailController,
    maxLines: 1,
    keyboardType: TextInputType.emailAddress,
    keyboardAppearance: Brightness.dark,
    validator: (value) {
      if (value.isEmpty)
        return 'Email cannot be empty';
      else if (emailInvalidRegex(value)) {
        return 'Entered email is invalid';
      } else {
        return null;
      }
    },
    decoration: InputDecoration(
        hintText: 'Email', icon: Icon(Icons.mail, color: Colors.black)),
  );
}

Widget passwordField(TextEditingController passwordController) {
  return TextFormField(
    controller: passwordController,
    maxLines: 1,
    obscureText: true,
    keyboardAppearance: Brightness.dark,
    validator: (value) {
      if (value.isEmpty)
        return 'Password cannot be empty';
      else if (value.length < 6)
        return 'Password must have atleast 6 characters';
      else
        return null;
    },
    decoration: InputDecoration(
      hintText: 'Password',
      icon: Icon(Icons.lock, color: Colors.black),
    ),
  );
}

Widget title() {
  return Center(
    child: Text(
      'Groto Shop',
      textScaleFactor: 2,
      style: TextStyle(
        fontFamily: 'NotoSerif',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget nameField(TextEditingController nameController) {
  return TextFormField(
    controller: nameController,
    maxLines: 1,
    keyboardType: TextInputType.text,
    autofocus: false,
    decoration: InputDecoration(
      hintText: 'Name',
      icon: Icon(Icons.person, color: Colors.black),
    ),
    validator: (value) {
      if (value.isEmpty)
        return 'Name cannot be empty';
      else
        return null;
    },
  );
}

class ClickableText extends GestureDetector {
  final VoidCallback onTap;
  final String text;

  ClickableText({@required this.onTap, this.text})
      : super(
            onTap: onTap,
            child: Text(
              text,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ));

  @override
  Widget build(BuildContext context) {
    return Builder(builder: super.build);
  }
}

class CircularBlackButton extends MaterialButton {
  CircularBlackButton({@required this.onPressed, this.child})
      : super(
          onPressed: onPressed,
          elevation: 0.0,
          child: child,
          color: Colors.black,
          minWidth: double.infinity,
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        );
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: super.build);
  }
}

class VerticalSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 30, color: Colors.transparent);
  }
}

void showSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String _error) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(_error)));
}

class StretchedCircularBlackButton extends MaterialButton {
  StretchedCircularBlackButton({@required this.onPressed, this.child})
      : super(
          onPressed: onPressed,
          elevation: 0.0,
          child: child,
          color: Colors.black,
          minWidth: double.infinity,
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        );
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: super.build);
  }
}
