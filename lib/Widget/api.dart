//==============================================================================
//========================= All API's here =====================================
import '../Helper/constant.dart';

final Uri getUserLoginApi = Uri.parse(baseUrl + 'login');
final Uri getVerifyUserApi = Uri.parse(baseUrl + 'verify_user');
final Uri getFundTransferApi = Uri.parse(baseUrl + 'get_fund_transfers');
final Uri getNotificationApi = Uri.parse(baseUrl + 'get_notifications');
final Uri updateFcmApi = Uri.parse(baseUrl + 'update_fcm');
final Uri getBoyDetailApi = Uri.parse(baseUrl + 'get_delivery_boy_details');
final Uri getUpdateUserApi = Uri.parse(baseUrl + 'update_user');
final Uri getSettingApi = Uri.parse(baseUrl + 'get_settings');
final Uri getOrdersApi = Uri.parse(baseUrl + 'get_orders');
final Uri getResetPassApi = Uri.parse(baseUrl + 'reset_password');
final Uri updateOrderItemApi = Uri.parse(baseUrl + 'update_order_item_status');
final Uri sendWithReqApi = Uri.parse(baseUrl + 'send_withdrawal_request');
final Uri getWithReqApi = Uri.parse(baseUrl + 'get_withdrawal_request');
final Uri getCashCollection =
    Uri.parse(baseUrl + 'get_delivery_boy_cash_collection');
final Uri deleteDeliveryBoyApi = Uri.parse(baseUrl + 'delete_delivery_boy');
final Uri getZipcodesApi = Uri.parse(baseUrl + 'get_zipcodes');
final Uri registerApi = Uri.parse(baseUrl + 'register');





