import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'app_config.dart';

class AuthProvider with ChangeNotifier {
  String _token;

  String get token {
    return _token != null ? _token : null;
  }

  bool get isAuth => token != null;

  AppConfig _appConfig;
  AppConfig get appConfig => _appConfig;

  set appConfig(AppConfig appConfigVal) {
    if (_appConfig != appConfigVal) {
      _appConfig = appConfigVal;
      notifyListeners();
    }
  }

  Future<void> login() async {
    try {
      final String url = '${appConfig.baseUrl}/login';

      await Future.delayed(Duration(seconds: 2));

      final http.Response response = await http.get(url);
      final responseData = json.decode(response.body);

      if (response.statusCode != 200 || !responseData['success']) {
        throw 'Fail to login';
      }

      _token = responseData['token'];

      if (appConfig.buildFlavor == 'dev') {
        print('token: $_token');
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', _token);

      notifyListeners();
    } catch (e) {
      if (appConfig.buildFlavor == 'dev') {
        print('error: $e');
      }
      throw e;
    }
  }

  Future<bool> tyrAutoLogin() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('jwtToken')) {
        return false;
      }

      _token = prefs.getString('jwtToken');

      notifyListeners();

      return true;
    } catch (e) {
      throw '로그인 여부 체크 실패';
    }
  }

  Future<void> logout() async {
    _token = null;

    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }
}
