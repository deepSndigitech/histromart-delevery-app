import 'package:deliveryboy_multivendor/Localization/Language_Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/parameterString.dart';
import 'UserProvider.dart';

class SettingProvider {
  late SharedPreferences _sharedPreferences;

  SettingProvider(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  String get email => _sharedPreferences.getString(EMAIL) ?? '';

  String? get userId => _sharedPreferences.getString(ID);

  String get userName => _sharedPreferences.getString(USERNAME) ?? '';

  String get mobile => _sharedPreferences.getString(MOBILE) ?? '';

  setPrefrence(String key, String value) {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getPrefrence(String key) async {
    return _sharedPreferences.getString(key);
  }

  void setPrefrenceBool(String key, bool value) async {
    _sharedPreferences.setBool(key, value);
  }

  setPrefrenceList(String key, String query) async {
    List<String> valueList = await getPrefrenceList(key);
    if (!valueList.contains(query)) {
      if (valueList.length > 4) valueList.removeAt(0);
      valueList.add(query);

      _sharedPreferences.setStringList(key, valueList);
    }
  }

  Future<List<String>> getPrefrenceList(String key) async {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  Future<bool> getPrefrenceBool(String key) async {
    return _sharedPreferences.getBool(key) ?? false;
  }

  setListPrefrence(String key, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, List<String>.from(value));
  }

  Future<List<String>?> getListPrefrence(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<void> clearUserSession(BuildContext context) async {
    CUR_USERID = null;

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    String? getLanguage = await getPrefrence(LAGUAGE_CODE);

    context.read<UserProvider>().setPincode('');
    userProvider.setName('');
    userProvider.setProfilePic('');
    userProvider.setMobile('');
    userProvider.setEmail('');
    CUR_USERID = '';
    CUR_USERNAME = "";
    CUR_BALANCE = '';
    CUR_BONUS = '';
    CUR_CURRENCY = '';
    CUR_DRIVING_LICENSE = [];
    await _sharedPreferences.clear();
    setPrefrence(LAGUAGE_CODE, getLanguage!);
  }

  Future<void> setCurrentSellerID(String value) async {
    setPrefrence('CurrentSellerID', value);
  }

  Future<String?> getCurrentSellerID(String value) async {
    return _sharedPreferences.getString('CurrentSellerID');
  }

  Future<void> saveUserDetail(String userId, String? name, String? email,
      String? mobile, BuildContext context) async {
    final waitList = <Future<void>>[];
    waitList.add(_sharedPreferences.setString(ID, userId));
    waitList.add(_sharedPreferences.setString(USERNAME, name ?? ''));
    waitList.add(_sharedPreferences.setString(EMAIL, email ?? ''));
    waitList.add(_sharedPreferences.setString(MOBILE, mobile ?? ''));

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.setName(name ?? '');
    userProvider.setMobile(mobile ?? '');
    userProvider.setEmail(email ?? '');
    await Future.wait(waitList);
  }
}

setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}
