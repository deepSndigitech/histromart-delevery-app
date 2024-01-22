import 'dart:async';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Model/zipcodeModel.dart';
import '../Repository/zipcodeRepository.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/setSnackbar.dart';
import '../Widget/translateVariable.dart';
import '../Widget/validation.dart';

class ZipcodeListProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Zipcode_Model> tempList = [];
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Zipcode_Model> zipcodeList = [];
  int offset = 0;
  int total = 0;
  bool? isLoadingmore;
  bool isLoading = true;
  StateSetter? zipcodeState;

  initalizeVariables() {
    tempList = [];
    zipcodeList = [];
    offset = 0;
    total = 0;
    isLoading = true;
  }

  loadingMoreNotifier() {
    isLoadingmore = true;
    notifyListeners();
  }

  setZipcodeState(StateSetter setStater) {
    zipcodeState = setStater;
    notifyListeners();
  }

  Future<Null> getZipcode(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
        };
        var getdata = await ZipcodeListRepository.getZipcodes(
          parameter: parameter,
        );
        bool error = getdata["error"];
        if (!error) {
          total = int.parse(
            getdata["total"],
          );
          if ((offset) < total) {
            tempList.clear();
            var data = getdata["data"];
            tempList = (data as List)
                .map(
                  (data) => Zipcode_Model.fromJson(data),
                )
                .toList();

            zipcodeList.addAll(tempList);

            offset = offset + perPage;
          }
        }

        isLoading = false;
        isLoadingmore = false;
        Future.microtask(() {
          zipcodeState?.call(() {});
        });
        update();
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, somethingMSg)!, context);
        isLoading = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      update();
    }
    return null;
  }
}
