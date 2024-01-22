import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:deliveryboy_multivendor/Widget/api.dart';
import 'package:deliveryboy_multivendor/Widget/setSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Repository/AuthRepository.dart';
import '../Widget/jwtkeySecurity.dart';
import '../Widget/parameterString.dart';

class SignupAuthenticationProvider extends ChangeNotifier {
  // value for parameter
  String? fullName, password;
  String? id, email, mobile;
  String? address;
  List zipCodesList = [];
  bool? error;
  String errorMessage = '';

  get mobilenumbervalue => mobile;

  setFullname(String? value) {
    fullName = value;
    notifyListeners();
  }

  setPassword(String? value) {
    password = value;
    notifyListeners();
  }

  setEmail(String? value) {
    email = value;
    notifyListeners();
  }

  setMobile(String? value) {
    mobile = value;
    notifyListeners();
  }

  setAddress(String? value) {
    address = value;
    notifyListeners();
  }

  setZipcodes(List? value) {
    zipCodesList = value!;
    notifyListeners();
  }

  //get System Policies
  Future<Map<String, dynamic>> getSignupData(
      {required String name,
      required String mobile,
      required String email,
      required String password,
      required String confirmPass,
      required String zipcodes,
      required String address,
      required List<File> licenses,
      required BuildContext context}) async {
    try {
      var request = MultipartRequest("POST", registerApi);
      request.headers.addAll(headers);
      request.fields[NAME] = name;
      request.fields[MOBILE] = mobile;
      request.fields[EMAIL] = email;
      request.fields[PASSWORD] = password;
      request.fields[CONFIRM_PASSWORD] = confirmPass;
      request.fields[SERVICEABLE_ZIPCODES] = zipcodes;
      request.fields[ADDRESS] = address;

      if (licenses.isNotEmpty) {
        for (var i = 0; i < licenses.length; i++) {
          var pic = await MultipartFile.fromPath(
            DRIVING_LICENSE_OTHER,
            licenses[i].path,
          );

          request.files.add(pic);
        }
      }
      print("request field****${request.fields}****${request.files}");

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      var getdata = json.decode(responseString);
      print("getdata******$getdata*******${response.statusCode}");
      bool error = getdata["error"];
      String msg = getdata['message'];


      return getdata;
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
        MOBILENO: mobile,
        NEWPASS: password,
      };

      var result = await AuthRepository.fetchFetchReset(parameter: parameter);
      return result;
    } catch (e) {
      errorMessage = e.toString();
      return {};
    }
  }
}
