import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime(0);
  String _userId = '';
  Timer _authTimer = Timer(Duration(seconds: 5), () {});

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != DateTime(0) &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        // Api key is on configuration section on firebase
        //TODO: create env files to move keys
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBDsk3hdpyKuwtQj0u76nDHU49wrbth2ic');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // we add this because firebase didnt response with error status
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
      //Shared preferences is a plugin that allow us to store somo data locally
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    _autoLogout();
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'] as String;
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime(0);
    notifyListeners;
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // this is remove by case just if we have more info that dont want to removei
    //prefs.remove('userData');
    //this will remove everything
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    //Timer allow us to run a specific command passed a certain amount of time
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
