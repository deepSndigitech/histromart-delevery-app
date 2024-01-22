import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../Localization/Demo_Localization.dart';

class StringValidation {
  static String? validateUserName(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, USER_REQUIRED)!;
    }
    if (value.length <= 1) {
      return getTranslated(context, USER_LENGTH)!;
    }
    return null;
  }

  static String? validateMob(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, MOB_REQUIRED)!;
    }
    if (value.length < 6 || value.length > 15) {
      return getTranslated(context, VALID_MOB)!;
    }
    return null;
  }

  static String? validateField(String? value, BuildContext context) {
    if (value!.length == 0)
      return getTranslated(context, FIELD_REQUIRED)!;
    else
      return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return getTranslated(context, 'EMAIL_REQUIRED');
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
            r'*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+'
            r'[a-z0-9](?:[a-z0-9-]*[a-z0-9])?')
        .hasMatch(value)) {
      return getTranslated(context, 'VALID_EMAIL');
    } else {
      return null;
    }
  }

  // static String? validatePass(String? value, BuildContext context) {
  //   if (value!.length == 0)
  //     return getTranslated(context, PWD_REQUIRED)!;
  //   else if (value.length <= 5)
  //     return getTranslated(context, PWD_LENGTH)!;
  //   else
  //     return null;
  // }

  static String? validatePass(String? value, BuildContext context,
      {required bool onlyRequired}) {
    if (onlyRequired) {
      if (value!.isEmpty) {
        return getTranslated(context, "PWD_REQUIRED")!;
      } else {
        return null;
      }
    } else {
      if (value!.isEmpty) {
        return getTranslated(context, "PWD_REQUIRED");
      } else if (!RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!%@#\$&*~_.?=^`-]).{8,}$')
          .hasMatch(value)) {
        return getTranslated(context, 'PASSWORD_VALIDATION')!;
      } else {
        return null;
      }
    }
  }

  static String? validateMobIntl(
      PhoneNumber? phoneNumber, BuildContext context) {
    if (phoneNumber == null || phoneNumber.number.isEmpty) {
      return getTranslated(context, MOB_REQUIRED)!;
    }
    if (phoneNumber.number.length < 6 || phoneNumber.number.length > 16) {
      return getTranslated(context, VALID_MOB);
    }
    return null;
  }

  static String? validateAltMob(String value, BuildContext context) {
    if (value.isNotEmpty) if (value.length < 9) {
      return getTranslated(context, VALID_MOB)!;
    }
    return null;
  }

  static String capitalize(String s) {
    if (s == '') {
      return '';
    }
    return s[0].toUpperCase() + s.substring(1);
  }
}

// for the translation of string
String? getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key);
}
