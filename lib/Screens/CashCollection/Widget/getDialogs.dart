import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../cash_collection.dart';

class GetDialogs {
  static void orderSortDialog(
    BuildContext context,
    Function update,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: const ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: AlertDialog(
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  circularBorderRadius5,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 19.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    getTranslated(context, ORDER_BY_TXT)!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, ASC_TXT)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    cashCollectionProvider!.cashList.clear();
                    cashCollectionProvider!.offset = 0;
                    cashCollectionProvider!.total = 0;
                    cashCollectionProvider!.isLoading = true;
                    update();
                    cashCollectionProvider!.getOrder(
                      cashCollectionProvider!.currentCashCollectionBy == "admin"
                          ? "admin"
                          : "delivery",
                      "ASC",
                      update,
                      context,
                    );
                    Navigator.pop(context, 'option 1');
                  },
                ),
                const Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, DESC_TXT)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    cashCollectionProvider!.cashList.clear();
                    cashCollectionProvider!.offset = 0;
                    cashCollectionProvider!.total = 0;
                    cashCollectionProvider!.isLoading = true;
                    update();
                    cashCollectionProvider!.getOrder(
                      cashCollectionProvider!.currentCashCollectionBy == "admin"
                          ? "admin"
                          : "delivery",
                      "DESC",
                      update,
                      context,
                    );
                    Navigator.pop(context, 'option 1');
                  },
                ),
                const Divider(
                  color: white,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void filterDialog(
    BuildContext context,
    Function update,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: const ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: AlertDialog(
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  circularBorderRadius5,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 19.0, bottom: 16.0),
                  child: Text(
                    getTranslated(context, FILTER_BY)!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, DELIVERY_BOY_CASH_TXT)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    cashCollectionProvider!.cashList.clear();
                    cashCollectionProvider!.offset = 0;
                    cashCollectionProvider!.total = 0;
                    cashCollectionProvider!.isLoading = true;
                    cashCollectionProvider!.isLoadingmore = true;
                    update();
                    cashCollectionProvider!.getOrder(
                      "delivery",
                      "DESC",
                      update,
                      context,
                    );
                    Navigator.pop(context, 'option 1');
                  },
                ),
                const Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, DELIVERY_BOY_CASH_COLL_TXT)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    cashCollectionProvider!.cashList.clear();
                    cashCollectionProvider!.offset = 0;
                    cashCollectionProvider!.total = 0;
                    cashCollectionProvider!.isLoading = true;
                    cashCollectionProvider!.isLoadingmore = true;
                    update();
                    cashCollectionProvider!.getOrder(
                      "admin",
                      "DESC",
                      update,
                      context,
                    );
                    Navigator.pop(context, 'option 1');
                  },
                ),
                const Divider(
                  color: white,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
