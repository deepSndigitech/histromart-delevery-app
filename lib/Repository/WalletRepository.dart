import 'dart:core';
import '../Helper/ApiBaseHelper.dart';
import '../Model/transaction_model.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class WalletRepository {
  //This method is used to fetch user wallet transactions
  static Future<Map<String, dynamic>> fetchWalletTransaction(
      {required Map<String, dynamic> parameter}) async {
    try {
      var requestAmountTransactionsList =
          await ApiBaseHelper().postAPICall(getFundTransferApi, parameter);

      return {
        'totalTransactions': requestAmountTransactionsList['total'].toString(),
        'walletTransactionList': (requestAmountTransactionsList['data'] as List)
            .map((transactionsData) =>
                (TransactionModel.fromJson(transactionsData)))
            .toList(),
      };
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }

  //
  //This method is used to send Amount withdrawal request
  static Future<Map<String, dynamic>> sendAmountWithdrawRequest(
      {required Map<String, dynamic> parameter}) async {
    try {
      var amountRequestData =
          await ApiBaseHelper().postAPICall(sendWithReqApi, parameter);

      return {
        'error': amountRequestData['error'],
        'message': amountRequestData['message'].toString(),
        'newBalance': amountRequestData['data'].toString()
      };
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }

//
//This method is used to get user wallet amount withdrawal request transactions
  static Future<Map<String, dynamic>>
      getWalletAmountWithdrawalRequestTransactions(
          {required Map<String, dynamic> parameter}) async {
    try {
      var requestTransactionsList =
          await ApiBaseHelper().postAPICall(getWithReqApi, parameter);

      return {
        'totalWalletAmountRequestTransactions':
            requestTransactionsList['total'].toString(),
        'walletAmountRequestTransactionList':
            (requestTransactionsList['data'] as List)
                .map((requestTransactionsData) =>
                    (TransactionModel.fromReqJson(requestTransactionsData)))
                .toList()
      };
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }
}
