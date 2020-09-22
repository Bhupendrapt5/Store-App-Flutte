import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/misc/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';
import 'package:shop_app/model/user_model.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId => _userId;

  Future<void> _authenticate(
      UserModel user, String urlSegment, String authType) async {
    try {
      final _url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${APIKeys.webApiKey}';
      var response = await http.post(_url, body: user.toJsonForSignUp());
      final resBody = json.decode(response.body);

      if (resBody['error'] != null) {
        throw HttpException(messge: resBody['error']['message']);
      }
      if (authType == 'logIn') {
        _token = resBody['idToken'];
        _userId = resBody['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              resBody['expiresIn'],
            ),
          ),
        );
        _autoLogout();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
        print(prefs.getString('userData'));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp({@required UserModel user}) {
    return _authenticate(user, 'signUp', 'signUp');
  }

  Future<void> logIn({@required UserModel user}) {
    return _authenticate(user, 'signInWithPassword', 'logIn');
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print('check login ${prefs.getString('userData')}');
    if (!prefs.containsKey('userData')) {
      print('got no userData');
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      debugPrint('stored time : $expiryDate');
      debugPrint('actula time : $_expiryDate');
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = DateTime.parse(extractedData['expiryDate']);

    debugPrint('actula time : $_expiryDate');
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
    print('logging out');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToExpiry), logOut);
    print('..logging out');
  }
}
