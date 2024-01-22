import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Localization/Language_Constant.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../../main.dart';
import '../home.dart';

class LanguageDialog {
  static languageDialog(
    BuildContext context,
    Function update,
  ) async {
    await dialogAnimate(
      context,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setStater) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius5),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                  child: Text(
                    getTranslated(context, ChooseLanguage)!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: black, fontSize: textFontSize18),
                  ),
                ),
                const Divider(color: lightBlack),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: getLngList(
                        context,
                        update,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static List<Widget> getLngList(
    BuildContext context,
    Function update,
  ) {
    final languageList = [
      getTranslated(context, 'English'),
      getTranslated(context, 'Hindi'),
      getTranslated(context, 'Chinese'),
      getTranslated(context, 'Spanish'),
      getTranslated(context, 'Arabic'),
      getTranslated(context, 'Russian'),
      getTranslated(context, 'Japanese'),
      getTranslated(context, 'Deutch'),
    ];
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            InkWell(
              onTap: () {
                homeProvider!.selectLan = index;
                _changeLan(homeProvider!.langCode[index], context);
                Navigator.of(context).pop();
                update();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 25.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: homeProvider!.selectLan == index
                                ? grad2Color
                                : white,
                            border: Border.all(color: grad2Color),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: homeProvider!.selectLan == index
                                ? const Icon(
                                    Icons.check,
                                    size: 17.0,
                                    color: white,
                                  )
                                : const Icon(
                                    Icons.check_box_outline_blank,
                                    size: 15.0,
                                    color: white,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Text(
                            languageList[index] ??"",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: lightBlack),
                          ),
                        )
                      ],
                    ),
                    index == languageList.length - 1
                        ? Container(
                            margin: const EdgeInsetsDirectional.only(
                              bottom: 10,
                            ),
                          )
                        : const Divider(
                            color: lightBlack,
                          ),
                  ],
                ),
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  static void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);

    MyApp.setLocale(ctx, _locale);
  }
}
