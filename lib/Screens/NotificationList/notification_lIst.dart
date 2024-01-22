import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/notificationListProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import 'Widget/listIteam.dart';

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateNoti();
}

NotificationListProvider? notificationListProvider;

class StateNoti extends State<NotificationList> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    notificationListProvider =
        Provider.of<NotificationListProvider>(context, listen: false);
    notificationListProvider!.initalizeVariables();

    notificationListProvider!.getNotification(context, setStateNow);
    notificationListProvider!.controller.addListener(_scrollListener);
    notificationListProvider!.buttonController = new AnimationController(
      duration: new Duration(milliseconds: 2000),
      vsync: this,
    );

    notificationListProvider!.buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: notificationListProvider!.buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    notificationListProvider!.buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await notificationListProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          notificationListProvider!.getNotification(context, setStateNow);
        } else {
          await notificationListProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  Future<Null> _refresh() {
    setState(
      () {
        notificationListProvider!.isLoading = true;
      },
    );
    notificationListProvider!.offset = 0;
    notificationListProvider!.total = 0;
    notificationListProvider!.notiList.clear();
    return notificationListProvider!.getNotification(context, setStateNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      key: notificationListProvider!.scaffoldKey,
      appBar: getAppBar(NOTIFICATION, context),
      body: isNetworkAvail
          ? notificationListProvider!.isLoading
              ? const ShimmerEffect()
              : notificationListProvider!.notiList.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      child: Center(
                        child: Text(
                          noNoti,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      key: notificationListProvider!.refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        controller: notificationListProvider!.controller,
                        itemCount: (notificationListProvider!.offset <
                                notificationListProvider!.total)
                            ? notificationListProvider!.notiList.length + 1
                            : notificationListProvider!.notiList.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return (index ==
                                      notificationListProvider!
                                          .notiList.length &&
                                  notificationListProvider!.isLoadingmore)
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListIteam(index: index);
                        },
                      ),
                    )
          : noInternet(
              context,
              setStateNoInternate,
              notificationListProvider!.buttonSqueezeanimation,
              notificationListProvider!.buttonController,
            ),
    );
  }

  _scrollListener() {
    if (notificationListProvider!.controller.offset >=
            notificationListProvider!.controller.position.maxScrollExtent &&
        !notificationListProvider!.controller.position.outOfRange) {
      if (this.mounted) {
        setState(
          () {
            notificationListProvider!.isLoadingmore = true;

            if (notificationListProvider!.offset <
                notificationListProvider!.total)
              notificationListProvider!.getNotification(context, setStateNow);
          },
        );
      }
    }
  }
}
