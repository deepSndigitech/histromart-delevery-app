import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../Authentication/Login/LoginScreen.dart';
import '../home.dart';

class LogOutDialog {
  static logOutDailog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              content: Text(
                getTranslated(context, LOGOUTTXT)!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, LOGOUTNO)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, LOGOUTYES)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    settingProvider!.clearUserSession(context);

                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => Login(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
