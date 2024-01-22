import 'dart:async';
import 'package:flutter/material.dart';
import '../Repository/AuthRepository.dart';
import '../Provider/signupProvider.dart';
import '../Widget/parameterString.dart';

class AuthenticationProvider extends ChangeNotifier {
  // value for parameter
  String? mobilennumberPara, passwordPara;

  //user data
  String? id, userName, email, mobile;

  // for reset password
  String? newPassword;

  // data
  bool? error;
  String errorMessage = '';

  get mobilenumbervalue => mobilennumberPara;

  setMobileNumber(String? value) {
    mobilennumberPara = value;
    notifyListeners();
  }

  setNewPassword(String? value) {
    newPassword = value;
    notifyListeners();
  }

  setPassword(String? value) {
    passwordPara = value;
    notifyListeners();
  }

  //get System Policies
  Future<Map<String, dynamic>> getLoginData() async {
    try {
      var parameter = {MOBILE: mobilennumberPara, PASSWORD: passwordPara};

      print("param***login****$parameter");
      var result = await AuthRepository.fetchLoginData(parameter: parameter);

      errorMessage = result['message'];
      error = result['error'];
      if (!error!) {
        var getdata = result['data'][0];
        id = getdata[ID];
        userName = getdata[USERNAME];
        email = getdata[EMAIL];
        mobile = getdata[MOBILE];
        CUR_USERID = id;
        return result;
      } else {
        return result;
      }
    } catch (e) {
      errorMessage = e.toString();
      return {};
    }
  }

  //for login
  Future<Map<String, dynamic>> getVerifyUser(String mobile) async {
    try {
      var parameter = {
        MOBILE: mobile,
      };
      var result =
          await AuthRepository.fetchverificationData(parameter: parameter);
      return result;
    } catch (e) {
      errorMessage = e.toString();
      return {};
    }
  }

  // for reset password
  Future<Map<String, dynamic>> getReset() async {
    try {
      var parameter = {
        MOBILENO: mobilennumberPara,
        NEWPASS: newPassword,
      };

      var result = await AuthRepository.fetchFetchReset(parameter: parameter);
      return result;
    } catch (e) {
      errorMessage = e.toString();
      return {};
    }
  }
}







