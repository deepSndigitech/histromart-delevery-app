import 'dart:async';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Model/notification_model.dart';
import '../Repository/notificationRepositry.dart';
import '../Screens/NotificationList/notification_lIst.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/setSnackbar.dart';
import '../Widget/translateVariable.dart';
import '../Widget/validation.dart';

class NotificationListProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller = new ScrollController();
  List<Notification_Model> tempList = [];
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Notification_Model> notiList = [];
  int offset = 0;
  int total = 0;
  bool isLoadingmore = true;
  bool isLoading = true;

  initalizeVariables() {
    tempList = [];
    notiList = [];
    offset = 0;
    total = 0;
    isLoadingmore = true;
    isLoading = true;
  }

  Future<Null> getNotification(
    BuildContext context,
    Function update,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: notificationListProvider!.offset.toString(),
        };
        var getdata = await NotificationListRepository.getNotifications(
          parameter: parameter,
        );
        bool error = getdata["error"];
        if (!error) {
          notificationListProvider!.total = int.parse(
            getdata["total"],
          );
          if ((notificationListProvider!.offset) <
              notificationListProvider!.total) {
            notificationListProvider!.tempList.clear();
            var data = getdata["data"];
            notificationListProvider!.tempList = (data as List)
                .map(
                  (data) => new Notification_Model.fromJson(data),
                )
                .toList();

            notificationListProvider!.notiList
                .addAll(notificationListProvider!.tempList);

            notificationListProvider!.offset =
                notificationListProvider!.offset + perPage;
          }
        } else {
          notificationListProvider!.isLoadingmore = false;
        }

        notificationListProvider!.isLoading = false;

        update();
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, somethingMSg)!, context);
        notificationListProvider!.isLoading = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      update();
    }
    return null;
  }
}
