import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/networkAvailablity.dart';
import '../../../Widget/validation.dart';
import '../home.dart';

class DeleteAccountDialog {
  static deleteAccountDailog(
    BuildContext context,
    Function update,
  ) async {
    await dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius5),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //==================
                // when currentIndex == 0
                //==================
                homeProvider!.currentIndex == 0
                    ? Text(
                        getTranslated(context, "Delete Account")!,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                homeProvider!.currentIndex == 0
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),
                homeProvider!.currentIndex == 0
                    ? Text(
                        getTranslated(
                          context,
                          'Your all return order request, ongoing orders, wallet amount and also your all data will be deleted. So you will not able to access this account further. We understand if you want you can create new account to use this application.',
                        )!,
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(),
                      )
                    : Container(),
                //==================
                // when currentIndex == 1
                //==================
                homeProvider!.currentIndex == 1
                    ? Text(
                        getTranslated(context, "Please Verify Password")!,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container(),
                homeProvider!.currentIndex == 1
                    ? const SizedBox(
                        height: 25,
                      )
                    : Container(),
                homeProvider!.currentIndex == 1
                    ? Container(
                        height: 53,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: lightWhite1,
                          borderRadius:
                              BorderRadius.circular(circularBorderRadius10),
                        ),
                        alignment: Alignment.center,
                        child: TextFormField(
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize13),
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(homeProvider!.passFocus);
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: homeProvider!.passwordController,
                          focusNode: homeProvider!.passFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            homeProvider!.verifyPassword = value;
                          },
                          onSaved: (String? value) {
                            homeProvider!.verifyPassword = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            suffixIconConstraints: const BoxConstraints(
                                minWidth: 40, maxHeight: 20),
                            hintText: getTranslated(context, 'Password'),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: textFontSize13,
                            ),
                            fillColor: lightWhite,
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : Container(),
                //==================
                // when currentIndex == 2
                //==================

                homeProvider!.currentIndex == 2
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
                //==================
                // when currentIndex == 2
                //==================
                homeProvider!.currentIndex == 3
                    ? Center(
                        child: Text(
                          homeProvider!.errorTrueMessage ??
                              getTranslated(context,
                                  "something Error Please Try again...!")!,
                        ),
                      )
                    : Container(),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  homeProvider!.currentIndex == 0
                      ? TextButton(
                          child: Text(
                            getTranslated(context, "No")!,
                            style:
                                Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        )
                      : Container(),
                  homeProvider!.currentIndex == 0
                      ? TextButton(
                          child: Text(
                            getTranslated(context, "Yes")!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                homeProvider!.currentIndex = 1;
                              },
                            );
                          },
                        )
                      : Container(),
                ],
              ),
              homeProvider!.currentIndex == 1
                  ? TextButton(
                      child: Text(
                        getTranslated(context, "Delete Now")!,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onPressed: () async {
                        setState(
                          () {
                            homeProvider!.currentIndex = 2;
                          },
                        );
                        await checkNetwork(
                          homeProvider!.mobileNumber ?? "",
                          update,
                          context,
                        ).then(
                          (value) {
                            setState(
                              () {
                                homeProvider!.currentIndex = 3;
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  static Future<void> checkNetwork(
    String mobile,
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      homeProvider!.deleteAccountAPI(mobile, update, context);
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          await homeProvider!.buttonController!.reverse();
          update(
            () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
}
