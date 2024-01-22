import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class AuthRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchLoginData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
      await ApiBaseHelper().postAPICall(getUserLoginApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }


  static Future<Map<String, dynamic>> fetchSignUpData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var signUpDetail =
      await ApiBaseHelper().postAPICall(registerApi, parameter);

      return signUpDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }


  static Future<Map<String, dynamic>> fetchverificationData({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
      await ApiBaseHelper().postAPICall(getVerifyUserApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }



  static Future<Map<String, dynamic>> fetchFetchReset({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
      await ApiBaseHelper().postAPICall(getResetPassApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }
}
