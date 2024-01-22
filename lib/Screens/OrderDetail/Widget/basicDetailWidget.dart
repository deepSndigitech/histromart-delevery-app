import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class BasicDetail extends StatelessWidget {
  Order_Model model;
  BasicDetail({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(circularBorderRadius5)),
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
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    getTranslated(context, ORDER_ID_LBL)! + " - ",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: grey3,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize14,
                        ),
                  ),
                  Text(
                    model.id!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: 'PlusJakartaSans',
                          color: black,
                          fontSize: textFontSize14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    "Order Date - ",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: grey3,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize14,
                        ),
                  ),
                  Text(
                    model.orderDate!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontFamily: 'PlusJakartaSans',
                          color: black,
                          fontSize: textFontSize14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${getTranslated(context, PAYMENT_MTHD)!} - ",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: grey3,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14,
                      ),
                ),
                Text(
                  model.payMethod!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontFamily: 'PlusJakartaSans',
                        color: black,
                        fontSize: textFontSize14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
