import 'package:deliveryboy_multivendor/Repository/WalletRepository.dart';
import 'package:flutter/material.dart';
import '../Helper/ApiBaseHelper.dart';
import '../Helper/constant.dart';
import '../Model/transaction_model.dart';
import '../Widget/parameterString.dart';

enum MyWalletStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class MyWalletProvider extends ChangeNotifier {
  MyWalletStatus _transactionStatus = MyWalletStatus.initial;
  List<TransactionModel> walletTransactionList = [];

//  List<TransactionModel> walletWithdrawalRequestList = [];
  String errorMessage = '';
  int transactionListOffset = 0;
  int transactionListTotal = 0;

  // int requestTransactionListOffset = 0;
  final int transactionsPerPage = perPage;

  bool walletTransactionHasMoreData = false,
      /*  walletTransactionIsLoadingMore = false,*/
      isLoading = true,
      currentSelectedFilterIsTransaction = true;

  set setCurrentSelectedFilterIsTransaction(value) {
    currentSelectedFilterIsTransaction = value;
    notifyListeners();
  }

  get getCurrentSelectedFilterIsTransaction =>
      currentSelectedFilterIsTransaction;

  get getCurrentStatus => _transactionStatus;

  changeStatus(MyWalletStatus status) {
    _transactionStatus = status;
    notifyListeners();
  }

  //
  //This method is used to fetchWalletTransactions
  Future<void> getUserWalletTransactions({
    required BuildContext context,
    required bool walletTransactionIsLoadingMore,
  }) async {
    try {
      var parameter = {
        LIMIT: transactionsPerPage.toString(),
        OFFSET: transactionListOffset.toString(),
        USER_ID: CUR_USERID,
      };

      // if (!walletTransactionIsLoadingMore) {
      if (!walletTransactionHasMoreData) {
        parameter[OFFSET] = '0';
        walletTransactionList.clear();
        changeStatus(MyWalletStatus.inProgress);
      }

      Map<String, dynamic> result =
          await WalletRepository.fetchWalletTransaction(parameter: parameter);
      List<TransactionModel> tempList = [];

      for (var element in (result['walletTransactionList'] as List)) {
        tempList.add(element);
      }

      walletTransactionList.addAll(tempList);

      transactionListTotal = int.parse(result['totalTransactions']);

      if (transactionListTotal > transactionListOffset) {
        transactionListOffset += transactionsPerPage;
        walletTransactionHasMoreData = true;
      } else {
        walletTransactionHasMoreData = false;
      }
      changeStatus(MyWalletStatus.isSuccsess);
    } catch (e) {
      errorMessage = e.toString();
      changeStatus(MyWalletStatus.isFailure);
    }
  }

//This method is used to get user wallet amount withdrawal request transactions
  Future<void> fetchUserWalletAmountWithdrawalRequestTransactions({
    required BuildContext context,
    required bool walletTransactionIsLoadingMore,
  }) async {
    try {
      var parameter = {
        LIMIT: transactionsPerPage.toString(),
        OFFSET: transactionListOffset.toString(),
        USER_ID: CUR_USERID,
      };

      if (!walletTransactionHasMoreData) {
        walletTransactionList.clear();
        changeStatus(MyWalletStatus.inProgress);
      }
      Map<String, dynamic> result =
          await WalletRepository.getWalletAmountWithdrawalRequestTransactions(
        parameter: parameter,
      );
      List<TransactionModel> tempList = [];

      for (var element
          in (result['walletAmountRequestTransactionList'] as List)) {
        tempList.add(element);
      }

      walletTransactionList.addAll(tempList);
      transactionListTotal =
          int.parse(result['totalWalletAmountRequestTransactions']);
      if (int.parse(result['totalWalletAmountRequestTransactions']) >
          transactionListOffset) {
        transactionListOffset += transactionsPerPage;
        walletTransactionHasMoreData = true;
      } else {
        walletTransactionHasMoreData = false;
      }
      changeStatus(MyWalletStatus.isSuccsess);
    } catch (e) {
      errorMessage = e.toString();
      changeStatus(MyWalletStatus.isFailure);
    }
  }

  Future<Map<String, dynamic>> sendAmountWithdrawRequest(
      {required String userID,
      required String withdrawalAmount,
      required String bankDetails}) async {
    try {
      changeStatus(MyWalletStatus.inProgress);

      var parameter = {
        USER_ID: userID,
        AMOUNT: withdrawalAmount,
        PAYMENT_ADD: bankDetails
      };

      Map<String, dynamic>? response =
          await WalletRepository.sendAmountWithdrawRequest(parameter: parameter)
              .then(
        (requestData) {
          if (!requestData['error']) {
            changeStatus(MyWalletStatus.isSuccsess);
            CUR_BALANCE =
                double.parse(requestData["newBalance"]).toStringAsFixed(2);
            return {
              'message': requestData['message'],
              'newBalance': requestData['newBalance'],
            };
          }
          if (requestData['message'] ==
              "You don't have enough balance to sent the withdraw request.") {
            changeStatus(MyWalletStatus.isSuccsess);

            return {
              'message': requestData['message'],
              'newBalance': withdrawalAmount,
            };
          } else {
            return {
              'message': 'Something went wrong',
              'newBalance': '',
            };
          }
        },
      ).onError(
        (error, stackTrace) {
          changeStatus(MyWalletStatus.isFailure);
          return {
            'message': error.toString(),
            'newBalance': '',
          };
        },
      );
      return response;
    } catch (e) {
      changeStatus(MyWalletStatus.isFailure);
      throw ApiException(e.toString());
    }
  }
}
