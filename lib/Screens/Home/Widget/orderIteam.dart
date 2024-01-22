import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../OrderDetail/order_detail.dart';
import '../home.dart';

class OrderIteam extends StatelessWidget {
  int index;
  Function update;

  OrderIteam({
    Key? key,
    required this.index,
    required this.update,
  }) : super(key: key);

  _launchCaller(index) async {
    var url = "tel:${homeProvider!.orderList[index].mobile}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Order_Model model = homeProvider!.orderList[index];
    Color back;
    if ((model.itemList![0].status!) == DELIVERD)
      back = Colors.green.withOpacity(0.85);
    else if ((model.itemList![0].status!) == SHIPED)
      back = Colors.orange.withOpacity(0.85);
    else if ((model.itemList![0].status!) == CANCLED ||
        model.itemList![0].status! == RETURNED)
      back = Colors.red.withOpacity(0.85);
    else if ((model.itemList![0].status!) == PROCESSED)
      back = Colors.indigo.withOpacity(0.85);
    else if (model.itemList![0].status! == WAITING)
      back = Colors.black;
    else if (model.itemList![0].status! == 'return_request_decline')
      back = Colors.red;
    else if (model.itemList![0].status! == 'return_request_pending')
      back = Colors.indigo.withOpacity(0.85);
    else
      back = Colors.cyan;
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 08.0,
                  start: 21,
                  end: 12,
                  bottom: 00,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          getTranslated(context, OrderNo)! + ".",
                          style: const TextStyle(color: grey),
                        ),
                        Text(
                          "${model.id!}",
                          style: const TextStyle(color: black),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: back,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(circularBorderRadius5))),
                      child: Text(
                        () {
                          if (model.itemList![0].status! == "delivered") {
                            return getTranslated(context, "delivered")!;
                          } else if (model.itemList![0].status! ==
                              "cancelled") {
                            return getTranslated(context, "cancelled")!;
                          } else if (model.itemList![0].status! == "returned") {
                            return getTranslated(context, "returned")!;
                          } else if (model.itemList![0].status! ==
                              "processed") {
                            return getTranslated(context, "processed")!;
                          } else if (model.itemList![0].status! == "shipped") {
                            return getTranslated(context, "shipped")!;
                          } else if (model.itemList![0].status! == "received") {
                            return getTranslated(context, "received")!;
                          } else if (model.itemList![0].status! ==
                              "return_request_pending") {
                            return getTranslated(
                                context, "RETURN_REQUEST_PENDING_LBL")!;
                          } else if (model.itemList![0].status! ==
                              "return_request_approved") {
                            return getTranslated(
                                context, "RETURN_REQUEST_APPROVE_LBL")!;
                          } else if (model.itemList![0].status! ==
                              "return_request_decline") {
                            return getTranslated(
                                context, "RETURN_REQUEST_DECLINE_LBL")!;
                          } else {
                            return StringValidation.capitalize(
                                model.itemList![0].status!);
                          }
                        }(),
                        style: const TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              if (model.mobile != "")
                Padding(
                  padding: const EdgeInsets.only(
                      right: 21.0, left: 21.0, bottom: 10, top: 5),
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 20),
                            Expanded(
                              child: Text(
                                model.name!.isNotEmpty
                                    ? " ${StringValidation.capitalize(model.name!)}"
                                    : " ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.call,
                              size: 20,
                              color: black,
                            ),
                            const SizedBox(width: 08),
                            Text(
                              "${model.mobile!}",
                              style: const TextStyle(
                                color: black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _launchCaller(index);
                        },
                      ),
                    ],
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 21.0, left: 21.0, bottom: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.money,
                          size: 20,
                        ),
                        Text(" " +
                            getTranslated(context, PAYABLE)! +
                            " : ${DesignConfiguration.getPriceFormat(
                              context,
                              double.parse(model.payable!),
                            )!}"),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          size: 20,
                        ),
                        const SizedBox(width: 08),
                        Text("${model.payMethod!}"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 21.0, left: 21.0, bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, size: 20),
                    Text(
                      " " +
                          getTranslated(context, OrderNo)! +
                          ": ${model.orderDate!}",
                    ),
                  ],
                ),
              )
            ],
          ),
          onTap: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => OrderDetail(
                  model: homeProvider!.orderList[index],
                ),
              ),
            );
            homeProvider!.getUserDetail(update, context);
            update();
          },
        ),
      ),
    );
  }
}
