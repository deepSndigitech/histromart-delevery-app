import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Model/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Provider/orderDetailProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'Widget/basicDetailWidget.dart';
import 'Widget/otpDialog.dart';
import 'Widget/priceDetailsWidget.dart';
import 'Widget/sellerDetailWidget.dart';
import 'Widget/shippingDetailsWidget.dart';

class OrderDetail extends StatefulWidget {
  final Order_Model? model;
  final Function? updateHome;

  const OrderDetail({
    Key? key,
    this.model,
    this.updateHome,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateOrder();
  }
}

OrderDetailProvider? orderDetailProvider;

class StateOrder extends State<OrderDetail> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    orderDetailProvider =
        Provider.of<OrderDetailProvider>(context, listen: false);
    orderDetailProvider!.initializeVariable();

    for (int i = 0; i < widget.model!.itemList!.length; i++) {
      widget.model!.itemList![i].curSelected =
          widget.model!.itemList![i].status;
    }

    if (widget.model!.payMethod == "Bank Transfer") {
      orderDetailProvider!.statusList
          .removeWhere((element) => element == PLACED);
    }

    orderDetailProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    orderDetailProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: orderDetailProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  void dispose() {
    orderDetailProvider!.buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await orderDetailProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
          (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await orderDetailProvider!.buttonController!.reverse();
          setState(
                () {},
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    Order_Model model = widget.model!;
    String? pDate, prDate, sDate, dDate, cDate, rDate;

    if (model.listStatus!.contains(PLACED)) {
      pDate = model.listDate![model.listStatus!.indexOf(PLACED)];

      if (pDate != "") {
        List d = pDate!.split(" ");
        pDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(PROCESSED)) {
      prDate = model.listDate![model.listStatus!.indexOf(PROCESSED)];
      if (prDate != "") {
        List d = prDate!.split(" ");
        prDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(SHIPED)) {
      sDate = model.listDate![model.listStatus!.indexOf(SHIPED)];
      if (sDate != "") {
        List d = sDate!.split(" ");
        sDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(DELIVERD)) {
      dDate = model.listDate![model.listStatus!.indexOf(DELIVERD)];
      if (dDate != "") {
        List d = dDate!.split(" ");
        dDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(CANCLED)) {
      cDate = model.listDate![model.listStatus!.indexOf(CANCLED)];
      if (cDate != "") {
        List d = cDate!.split(" ");
        cDate = d[0] + "\n" + d[1];
      }
    }
    if (model.listStatus!.contains(RETURNED)) {
      rDate = model.listDate![model.listStatus!.indexOf(RETURNED)];
      if (rDate != "") {
        List d = rDate!.split(" ");
        rDate = d[0] + "\n" + d[1];
      }
    }

    orderDetailProvider!.isCancleable =
    model.isCancleable == "1" ? true : false;
    orderDetailProvider!.isReturnable =
    model.isReturnable == "1" ? true : false;

    return Scaffold(
      key: orderDetailProvider!.scaffoldKey,
      backgroundColor: lightWhite,
      body: isNetworkAvail
          ? Stack(
        children: [
          Column(
            children: [
              GradientAppBar(
                getTranslated(context, ORDER_DETAIL)!,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: orderDetailProvider!.controller,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 15.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Column(
                      children: [
                        BasicDetail(model: model),
                        model.delDate != null && model.delDate!.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      circularBorderRadius5)),
                              color: white,
                              boxShadow: const [
                                BoxShadow(
                                    color: blarColor,
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    spreadRadius: 0),
                              ],
                            ),
                            height: 52,
                            width:
                            MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 6.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 6.0,
                              ),
                              child: Text(
                                getTranslated(context,
                                    PREFER_DATE_TIME)! +
                                    ": ${model.delDate!} - ${model.delTime!}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                  fontFamily: 'PlusJakartaSans',
                                  color: grey3,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        )
                            : Container(),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.itemList!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              OrderItem orderItem = model.itemList![i];
                              return productItem(orderItem, model, i);
                            },
                          ),
                        ),
                        ShippingDetails(
                          model: model,
                        ),
                        PriceDetails(
                          model: widget.model!,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          DesignConfiguration.showCircularProgress(
            orderDetailProvider!.isProgress,
            primary,
          ),
        ],
      )
          : noInternet(
        context,
        setStateNoInternate,
        orderDetailProvider!.buttonSqueezeanimation,
        orderDetailProvider!.buttonController,
      ),
    );
  }

  Widget productItem(OrderItem orderItem, Order_Model model, int i) {
    List att = [], val = [];
    if (orderItem.attr_name!.isNotEmpty) {
      att = orderItem.attr_name!.split(',');
      val = orderItem.varient_values!.split(',');
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
          boxShadow: const [
            BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 0,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(10.0),
                    child: DesignConfiguration.getCacheNotworkImage(
                      boxFit: BoxFit.cover,
                      context: context,
                      heightvalue: 94.0,
                      imageurlString: orderItem.image!,
                      placeHolderSize: 150.0,
                      widthvalue: 64.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              orderItem.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                color: black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "PlusJakartaSans",
                                fontStyle: FontStyle.normal,
                                fontSize: textFontSize13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          orderItem.attr_name!.isNotEmpty
                              ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: att.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        att[index].trim() + ":",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                          color: grey3,
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                          "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize13,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0),
                                      child: Text(
                                        val[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                          "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize13,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  getTranslated(context, QUANTITY_LBL)! + ":",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                    color: lightBlack2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    orderItem.qty!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                      color: black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (orderItem.status == 'return_request_approved' ||
                              orderItem.status == 'return_request_pending' ||
                              orderItem.status == 'return_request_decline')
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        getTranslated(
                                            context, 'ACTIVE_STATUS_LBL')! +
                                            ":",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                          color: lightBlack2,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                            () {
                                          if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Received") {
                                            return getTranslated(
                                                context, "received")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Processed") {
                                            return getTranslated(
                                                context, "processed")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Shipped") {
                                            return getTranslated(
                                                context, "shipped")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Delivered") {
                                            return getTranslated(
                                                context, "delivered")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Returned") {
                                            return getTranslated(
                                                context, "returned")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Cancelled") {
                                            return getTranslated(
                                                context, "cancelled")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Return_request_pending") {
                                            return getTranslated(context,
                                                "RETURN_REQUEST_PENDING_LBL")!;
                                          } else if (StringValidation.capitalize(
                                              orderItem.status!) ==
                                              "Return_request_approved") {
                                            return getTranslated(context,
                                                "RETURN_REQUEST_APPROVE_LBL")!;
                                          } else if (StringValidation
                                              .capitalize(
                                              orderItem.status!) ==
                                              "Return_request_decline") {
                                            return getTranslated(context,
                                                "RETURN_REQUEST_DECLINE_LBL")!;
                                          }
                                          return StringValidation.capitalize(
                                              orderItem.status!);
                                        }(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                          color: black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          Text(
                            "${DesignConfiguration.getPriceFormat(context, double.parse(orderItem.price!))!}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              color: primary,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PlusJakartaSans",
                              fontStyle: FontStyle.normal,
                              fontSize: textFontSize13,
                            ),
                          ),
                          widget.model!.itemList!.length >= 1
                              ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding:
                                    const EdgeInsetsDirectional.only(
                                        end: 8.0),
                                    child: DropdownButtonFormField(
                                      dropdownColor: lightBlack,
                                      isDense: true,
                                      iconEnabledColor: primary,
                                      hint: Text(
                                        getTranslated(
                                            context, UpdateStatus)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        fillColor: white,
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primary,
                                          ),
                                        ),
                                      ),
                                      value:
                                      (orderItem.status ==
                                          'return_request_approved' ||
                                          orderItem.status ==
                                              'return_request_pending' ||
                                          orderItem.status ==
                                              'return_request_decline')
                                          ? null
                                          : orderItem.status,
                                      onChanged: (dynamic newValue) {
                                        setState(
                                              () {
                                            orderItem.curSelected =
                                                newValue;
                                          },
                                        );
                                      },
                                      items: orderDetailProvider!
                                          .statusList
                                          .map(
                                            (String st) {
                                          return DropdownMenuItem<String>(
                                            value: st,
                                            child: Text(
                                                  () {
                                                if (StringValidation
                                                    .capitalize(st) ==
                                                    "Received") {
                                                  return getTranslated(
                                                      context,
                                                      "received")!;
                                                } else if (StringValidation
                                                    .capitalize(st) ==
                                                    "Processed") {
                                                  return getTranslated(
                                                      context,
                                                      "processed")!;
                                                } else if (StringValidation
                                                    .capitalize(st) ==
                                                    "Shipped") {
                                                  return getTranslated(
                                                      context,
                                                      "shipped")!;
                                                } else if (StringValidation
                                                    .capitalize(st) ==
                                                    "Delivered") {
                                                  return getTranslated(
                                                      context,
                                                      "delivered")!;
                                                } else if (StringValidation
                                                    .capitalize(st) ==
                                                    "Returned") {
                                                  return getTranslated(
                                                      context,
                                                      "returned")!;
                                                } else if (StringValidation
                                                    .capitalize(st) ==
                                                    "Cancelled") {
                                                  return getTranslated(
                                                      context,
                                                      "cancelled")!;
                                                }
                                                /*else if (StringValidation
                                                              .capitalize(st) ==
                                                          "Return_request_pending") {
                                                        return getTranslated(
                                                            context,
                                                            "RETURN_REQUEST_PENDING_LBL")!;
                                                      } else if (StringValidation
                                                              .capitalize(st) ==
                                                          "Return_request_approved") {
                                                        return getTranslated(
                                                            context,
                                                            "RETURN_REQUEST_APPROVE_LBL")!;
                                                      } else if (StringValidation
                                                              .capitalize(st) ==
                                                          "Return_request_decline") {
                                                        return getTranslated(
                                                            context,
                                                            "RETURN_REQUEST_DECLINE_LBL")!;
                                                      }*/
                                                return StringValidation
                                                    .capitalize(st);
                                              }(),
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                color: primary,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RawMaterialButton(
                                    constraints:
                                    const BoxConstraints.expand(
                                      width: 42,
                                      height: 42,
                                    ),
                                    onPressed: () {
                                      if (orderItem.item_otp != "" &&
                                          orderItem
                                              .item_otp!.isNotEmpty &&
                                          orderItem.item_otp != "0" &&
                                          orderItem.curSelected ==
                                              DELIVERD) {
                                        GetOtpDailog.otpDialog(
                                          orderItem.curSelected,
                                          orderItem.item_otp,
                                          model.id,
                                          true,
                                          i,
                                          context,
                                          model,
                                          setStateNow,
                                        );
                                      } else {
                                        orderDetailProvider!.updateOrder(
                                          orderItem.curSelected,
                                          model.id,
                                          true,
                                          i,
                                          orderItem.item_otp,
                                          setStateNow,
                                          context,
                                          widget.model,
                                        );
                                      }
                                    },
                                    elevation: 2.0,
                                    fillColor: primary,
                                    padding:
                                    const EdgeInsets.only(left: 5),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.send,
                                        size: 20,
                                        color: white,
                                      ),
                                    ),
                                    shape: const CircleBorder(),
                                  ),
                                )
                              ],
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ExpansionTile(
                children: [
                  SellerDetails(
                    index: i,
                    model: widget.model!,
                  ),
                ],
                title: Text(
                  getTranslated(context, SELLER_DETAILS)!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: 'PlusJakartaSans',
                    color: black,
                    fontSize: textFontSize14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
