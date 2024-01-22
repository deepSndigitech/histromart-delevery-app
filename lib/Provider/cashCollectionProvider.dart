import 'dart:async';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Model/cash_collection_model.dart';
import '../Repository/cashCollectionRepositry.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/setSnackbar.dart';
import '../Widget/translateVariable.dart';

class CashCollectionProvider extends ChangeNotifier {
  List<CashColl_Model> tempList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ScrollController controller = ScrollController();
  TextEditingController controllerText = TextEditingController();
  String searchText = "", lastsearch = "", currentCashCollectionBy = "";
  bool isLoadingmore = true, isGettingdata = false, isNodata = false;
  int? total, offset;
  List<CashColl_Model> cashList = [];
  bool isLoading = true;

  initalizeVaribleValues() {
    tempList = [];
    controllerText.clear();
    searchText = "";
    lastsearch = "";
    currentCashCollectionBy = "";
    isLoadingmore = true;
    isGettingdata = false;
    isNodata = false;
    cashList = [];
    total = null;
    offset = null;
    isLoading = true;
  }

  Future<void> getOrder(
    String from,
    String order,
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        if (isLoadingmore) {
          isLoadingmore = false;
          isGettingdata = true;
          if (offset == 0) {
            cashList = [];
          }
          update();

          if (CUR_USERID != null) {
            var parameter = {
              DELIVERY_BOY_ID: CUR_USERID,
              STATUS: from == "delivery"
                  ? DELIVERY_BOY_CASH
                  : DELIVERY_BOY_CASH_COLL,
              LIMIT: perPage.toString(),
              OFFSET: offset.toString(),
              ORDER_BY: order,
              SEARCH: searchText.trim(),
            };
            print("param****$parameter");
            var getdata = await CashCollectionRepository.getCashCollections(
              parameter: parameter,
            );

            print("getdata*****$getdata");

            bool error = getdata["error"];

            isGettingdata = false;
            if (offset == 0) isNodata = error;

            if (!error) {
              var data = getdata["data"];
              if (data.length != 0) {
                List<CashColl_Model> items = [];
                List<CashColl_Model> allitems = [];
                items.addAll((data as List)
                    .map((data) => CashColl_Model.fromJson(data))
                    .toList());
                allitems.addAll(items);
                print("cash collection11***");
                for (CashColl_Model item in items) {
                  cashList.where((i) => i.id == item.id).map(
                    (obj) {
                      allitems.remove(item);
                      return obj;
                    },
                  ).toList();
                }
                print("cash collection***");
                cashList.addAll(allitems);
                isLoadingmore = true;
                offset = offset! + perPage;
                print("cash collection22***");
              } else {
                isLoadingmore = false;
              }
            } else {
              isLoadingmore = false;
            }

            isLoading = false;
            currentCashCollectionBy = from;
            update();
          } else {
            isLoading = false;
            isLoadingmore = false;
            update();
          }
        } else {
          isLoading = false;
          update();
        }
      } on TimeoutException catch (_) {
        isLoading = false;
        isLoadingmore = false;
        update();

        setSnackbar(somethingMSg, context);
      } catch (e) {
        print(e.toString());
      }
    } else {
      isNetworkAvail = false;
      isLoading = false;
      update();
    }
    return;
  }
}
