import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:groto_shop/services/database_service.dart';
import 'package:groto_shop/shared/retailer.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  Database _databaseService = Database();
  Retailer _retailer;
  String _error = '';

  Future<Retailer> isLoggedIn() async {
    try {
    _firebaseUser = await _firebaseAuth.currentUser();
    if (_firebaseUser == null) return null;
    _retailer = await _databaseService.fetchFromDatabase(id: _firebaseUser.uid);
    } catch (e) {
      return null;
    }
    return _retailer;
  }

  Future<Retailer> loginWithEmail(
      {@required String email, String password}) async {
    try {
      _firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return _databaseService.fetchFromDatabase(id: _firebaseUser.uid);
    } on PlatformException catch (e) {
      if (e.code == PlatformException(code: 'ERROR_WRONG_PASSWORD').code) {
        _error = 'Error: Password is incorrect';
      } else if (e.code ==
          PlatformException(code: 'ERROR_INVALID_EMAIL').code) {
        _error = 'Error: Entered email is not valid';
      } else if (e.code ==
          PlatformException(code: 'ERROR_USER_DISABLED').code) {
        _error = 'Error: User is disabled (Contact Support)';
      } else if (e.code ==
          PlatformException(code: 'ERROR_USER_NOT_FOUND').code) {
        _error = 'Error: User not found';
      } else {
        _error = 'Error: ' + e.code;
      }
      throw _error;
    }
  }

  Future<Retailer> loginWithGmail() async {
    try {} on PlatformException catch (e) {
      if (e.code == PlatformException(code: 'ERROR_WRONG_PASSWORD').code) {
        _error = 'Error: Password is incorrect';
      } else if (e.code ==
          PlatformException(code: 'ERROR_INVALID_EMAIL').code) {
        _error = 'Error: Entered email is not valid';
      } else if (e.code ==
          PlatformException(code: 'ERROR_USER_DISABLED').code) {
        _error = 'Error: User is disabled (Contact Support)';
      } else {
        _error = 'Error: ' + e.code;
      }
      throw _error;
    }
  }

  Future<Retailer> createAccount({
    @required String name,
    String phone,
    String email,
    String password,
    String shop,
    String firstline,
    String secondline,
    String city,
  }) async {
    try {
      _firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      await _databaseService.createProfile(
        id: _firebaseUser.uid,
        email: email,
        name: name,
        phone: phone,
        shop: shop,
        firstline: firstline,
        secondline: secondline,
        city: city,
      );
      _retailer =
          await _databaseService.fetchFromDatabase(id: _firebaseUser.uid);
      return _retailer;
    } on PlatformException catch (e) {
      if (e.code == PlatformException(code: 'ERROR_INVALID_EMAIL').code) {
        _error = 'Error: Entered email is not valid';
      } else if (e.code ==
          PlatformException(code: 'ERROR_USER_DISABLED').code) {
        _error = 'Error: User is disabled (Contact Support)';
      } else if (e.code ==
          PlatformException(code: 'ERROR_EMAIL_ALREADY_IN_USE').code) {
        _error = 'Error: Email already in use';
      } else {
        _error = 'Error: ' + e.code;
      }
      throw _error;
    }
  }

  Future<void> resetPassword({@required email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw e;
    }
  }
}
