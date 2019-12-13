import 'package:flutter/cupertino.dart';
import 'package:groto_shop/enums/view_state.dart';
import 'package:groto_shop/models/base_model.dart';
import 'package:groto_shop/services/authentication_service.dart';
import 'package:groto_shop/services/database_service.dart';
import 'package:groto_shop/shared/retailer.dart';

class RetailerModel extends BaseModel {
  AuthService _authService = AuthService();
  Database _database = Database();
  Retailer _retailer;

  RetailerModel({Retailer retailer}) {
    this._retailer = retailer;
  }

  String get name => _retailer.name;

  String get id => _retailer.id;

  String get shop => _retailer.shop;

  String get firstline => _retailer.address['firstline'];

  String get secondline => _retailer.address['secondline'];

  String get city => _retailer.address['city'];

  double get rating => _retailer.rating;

  String get status => _retailer.status;

  Future<void> logInEmail(String email, String password) async {
    setState(ViewState.BUSY);
    try {
      _retailer =
          await _authService.loginWithEmail(email: email, password: password);
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> createUserWithEmail(
      {@required String name,
      String phone,
      String email,
      String password,
      String shop,
      String firstline,
      String secondline,
      String city}) async {
    setState(ViewState.BUSY);
    try {
      _retailer = await _authService.createAccount(
        name: name,
        phone: phone,
        email: email,
        password: password,
        shop: shop,
        firstline: firstline,
        secondline: secondline,
        city: city,
      );
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> logOut() async {
    setState(ViewState.BUSY);
    try {
      await _authService.logOut();
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> changeShopState() async {
    setState(ViewState.BUSY);
    try {
      await _database.changeStatus(_retailer.id, _retailer.status);
      _retailer.status = _retailer.status == 'open' ? 'closed' : 'open';
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }

  Future<void> resetPassword({@required String email}) async {
    setState(ViewState.BUSY);
    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      throw e;
    } finally {
      setState(ViewState.IDLE);
    }
  }
}
