//======================= AppBar Widget ========================================
import 'package:deliveryboy_multivendor/Widget/parameterString.dart';
import 'package:flutter/material.dart';
import '../Helper/color.dart';
import '../Helper/constant.dart';

getAppBar(String title, BuildContext context) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(circularBorderRadius5),
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: primary,
                size: 30,
              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        color: primary,
      ),
    ),
    backgroundColor: white,
  );
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [grad1Color, grad2Color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Opacity(
              opacity: 0.17000000178813934,
              child: Container(
                  width: deviceWidth! * 0.9,
                  height: 1,
                  decoration: const BoxDecoration(color: white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsetsDirectional.only(start: 15.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: white,
                      size: 25,
                    ),
                  ),
                ),
                Container(
                  height: 36,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 9.0,
                      start: 15,
                      end: 15,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: white,
                        fontSize: textFontSize16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
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
