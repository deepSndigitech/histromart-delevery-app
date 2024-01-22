import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../cash_collection.dart';

class GetCardValue extends StatelessWidget {
  const GetCardValue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: primary,
                  ),
                  Text(
                    " " + getTranslated(context, TOTAL_AMT)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              cashCollectionProvider!.cashList.isNotEmpty
                  ? Text(
                      DesignConfiguration.getPriceFormat(
                          context,
                          double.parse(cashCollectionProvider!
                              .cashList[0].cashReceived!))!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : Text(
                      DesignConfiguration.getPriceFormat(
                          context, double.parse(" 0"))!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
