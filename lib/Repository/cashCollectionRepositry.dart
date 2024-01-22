import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class CashCollectionRepository {
  //
  //This method is used to fetch System policies {e.g. Privacy Policy, T&C etc..}
  static Future<Map<String, dynamic>> getCashCollections({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
      await ApiBaseHelper().postAPICall(getCashCollection, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }


}
