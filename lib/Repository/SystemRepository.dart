import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class SystemRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> fetchSystemPolicies(
      {required Map<String, dynamic> parameter,
      required String policyType}) async {
    try {
      var policy = await ApiBaseHelper().postAPICall(getSettingApi, parameter);

      return policy;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg ${e.toString()}');
    }
  }
}
