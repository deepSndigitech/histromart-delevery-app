import 'package:deliveryboy_multivendor/Widget/setSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Provider/WalletProvider.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

String? validateField(String? value, BuildContext context) {
  if (value!.isEmpty) {
    return getTranslated(context, FIELD_REQUIRED)!;
  } else {
    return null;
  }
}

class GetDialogs {
  static void withDrawMonetDiolog(
      BuildContext ctx,
      TextEditingController? amtC,
      acc_num,
      ifsc_code,
      acc_name,
      bankDetailC,
      GlobalKey<FormState> _formkey) async {
    await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        20.0,
                        0,
                        2.0,
                      ),
                      child: Text(
                        getTranslated(context, SEND_REQUEST)!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const Divider(),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  validateField(value, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, WITHDRWAL_AMT)!,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: amtC,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Text(getTranslated(context, BANK_DETAIL)!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              validator: (value) =>
                                  validateField(value, context),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, "Account Number"),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: acc_num,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              validator: (value) =>
                                  validateField(value, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: getTranslated(context, "IFSC Code"),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: ifsc_code,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              validator: (value) =>
                                  validateField(value, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: getTranslated(context, "BK_NAME"),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: acc_name,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // content: SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.fromLTRB(
              //           20.0,
              //           20.0,
              //           0,
              //           2.0,
              //         ),
              //         child: Text(
              //           getTranslated(context, SEND_REQUEST)!,
              //           style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //                 color: primary,
              //               ),
              //         ),
              //       ),
              //       Divider(
              //         color: lightBlack,
              //       ),
              //       Form(
              //         key: _formkey,
              //         child: Column(
              //           children: <Widget>[
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              //               child: TextFormField(
              //                 keyboardType: TextInputType.number,
              //                 validator: (val) =>
              //                     StringValidation.validateField(val, context),
              //                 autovalidateMode:
              //                     AutovalidateMode.onUserInteraction,
              //                 decoration: InputDecoration(
              //                   hintText:
              //                       getTranslated(context, WITHDRWAL_AMT)!,
              //                   hintStyle: Theme.of(context)
              //                       .textTheme
              //                       .titleMedium!
              //                       .copyWith(
              //                         color: lightBlack,
              //                         fontWeight: FontWeight.normal,
              //                       ),
              //                 ),
              //                 controller: amtC,
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(
              //                 20.0,
              //                 0,
              //                 20.0,
              //                 0,
              //               ),
              //               child: TextFormField(
              //                 validator: (val) =>
              //                     StringValidation.validateField(val, context),
              //                 keyboardType: TextInputType.multiline,
              //                 maxLines: null,
              //                 autovalidateMode:
              //                     AutovalidateMode.onUserInteraction,
              //                 decoration: InputDecoration(
              //                   hintText: BANK_DETAIL,
              //                   hintStyle: Theme.of(context)
              //                       .textTheme
              //                       .titleMedium!
              //                       .copyWith(
              //                         color: lightBlack,
              //                         fontWeight: FontWeight.normal,
              //                       ),
              //                 ),
              //                 controller: bankDetailC,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, CANCEL)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, SEND_LBL)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    final form = _formkey.currentState!;
                    if (form.validate()) {
                      form.save();
                      Navigator.pop(context);
                      context
                          .read<MyWalletProvider>()
                          .sendAmountWithdrawRequest(
                              userID: CUR_USERID!,
                              bankDetails:
                                  "${acc_num!.text.toString()}\n${ifsc_code!.text.toString()}\n${acc_name!.text.toString()}",
                              withdrawalAmount: amtC!.text.toString())
                          .then((value) {
                        print("value =  ${value['message']}");
                        setSnackbar(value['message'], ctx);
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void filterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: AlertDialog(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  circularBorderRadius5,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(
              0.0,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 19.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    getTranslated(context, FILTER_BY)!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Divider(
                  color: lightBlack,
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, SHOW_TRANS)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    context
                        .read<MyWalletProvider>()
                        .walletTransactionList
                        .clear();
                    context.read<MyWalletProvider>().transactionListOffset = 0;
                    context.read<MyWalletProvider>().transactionListTotal = 0;
                    context.read<MyWalletProvider>().isLoading = true;
                    context.read<MyWalletProvider>().getUserWalletTransactions(
                        context: context, walletTransactionIsLoadingMore: true);
                    Navigator.pop(context, 'option 1');
                  },
                ),
                Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, SHOW_REQ)!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    context
                        .read<MyWalletProvider>()
                        .walletTransactionList
                        .clear();
                    context.read<MyWalletProvider>().transactionListOffset = 0;
                    context.read<MyWalletProvider>().transactionListTotal = 0;
                    context.read<MyWalletProvider>().isLoading = true;
                    context
                        .read<MyWalletProvider>()
                        .fetchUserWalletAmountWithdrawalRequestTransactions(
                            context: context,
                            walletTransactionIsLoadingMore: true);
                    Navigator.pop(context, 'option 1');
                  },
                ),
                Divider(
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
