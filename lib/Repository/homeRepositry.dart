import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class HomeRepository {
  //
  static Future<Map<String, dynamic>> getOrders({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getOrdersApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getSettings({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getSettingApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getUserDetail({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(getBoyDetailApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> deleteAccountAPI({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail =
          await ApiBaseHelper().postAPICall(deleteDeliveryBoyApi, parameter);

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }
}
