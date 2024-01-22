import 'package:flutter/material.dart';
import '../Repository/UserRepository.dart';
import 'SettingsProvider.dart';

enum UserStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class UserProvider extends ChangeNotifier {
  UserStatus _userStatus = UserStatus.initial;
  String errorMessage = '';
  String _userName = '',
      _mob = '',
      _profilePic = '',
  _fullName='',
  _password = '',
  _address = '',
      _email = '';
  String? _userId = '';
List _zipcodes = [];
  String? _curPincode = '';
String get fullName => _fullName;
String get password => _password;
String get address => _address;
List get zipcodes =>_zipcodes;
  late SettingProvider settingsProvider;

  String get curUserName => _userName;

  String get curPincode => _curPincode ?? '';



  String get mob => _mob;

  String get profilePic => _profilePic;

  String? get userId => _userId;

  String get email => _email;


  //signup
  void setFullname(String fullname) {
    _fullName = fullname;
    notifyListeners();
  }
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
  void setzipcodes(List zipcodes) {
    _zipcodes = zipcodes;
    notifyListeners();
  }






  //signup






  void setPincode(String pin) {
    _curPincode = pin;
    notifyListeners();
  }

  void setName(String count) {
    _userName = count;
    notifyListeners();
  }

  void setMobile(String count) {
    _mob = count;
    notifyListeners();
  }

  void setProfilePic(String count) {
    _profilePic = count;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUserId(String? count) {
    _userId = count;
  }

  UserStatus get userStatus => _userStatus;

  changeStatus(UserStatus status) {
    _userStatus = status;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateUserProfile(
      {required String userID,
         oldPassword,
         newPassword,
        username,
        userEmail}) async {
    try {
      changeStatus(UserStatus.inProgress);
      Map result = await UserRepository.updateUser(
          userID: userID,
          newPwd: newPassword,
          oldPwd: oldPassword,
          userEmail: userEmail,
          username: username);
      changeStatus(UserStatus.isSuccsess);
      return {'error': result['error'], 'message': result['message']};
    } catch (e) {
      errorMessage = e.toString();
      changeStatus(UserStatus.isFailure);
      return {'error': true, 'message': e.toString()};
    }
  }




}
