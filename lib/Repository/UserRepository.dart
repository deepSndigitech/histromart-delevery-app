import 'dart:core';
import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/parameterString.dart';
import '../Widget/translateVariable.dart';

class UserRepository {
  //This method is used to update user profile
  static Future<Map<String, dynamic>> updateUser(
      {required String userID, oldPwd, newPwd, username, userEmail}) async {
    try {
      var data = {USER_ID: userID,USERNAME:username,EMAIL:userEmail};
      if ((oldPwd != null) && (newPwd != null)) {
        data[OLDPASS] = oldPwd;
        data[NEWPASS] = newPwd;
      }
      final result = await ApiBaseHelper().postAPICall(getUpdateUserApi, data);

      bool error = result['error'];
      String? msg = result['message'];

      return {'error': error, 'message': msg};
    } catch (e) {
      throw ApiException('$somethingMSg,${e.toString()}');
    }
  }

}
