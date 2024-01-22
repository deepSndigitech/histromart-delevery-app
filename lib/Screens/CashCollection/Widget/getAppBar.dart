import 'package:deliveryboy_multivendor/Screens/CashCollection/Widget/getDialogs.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/parameterString.dart';

getAppBar(String title, BuildContext context, Function update, bool isBack) {
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
              decoration: const BoxDecoration(
                color: white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: isBack
                    ? InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(start: 15.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: white,
                            size: 25,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 15,
                      ),
              ),
              Container(
                height: 36,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 9.0,
                    /*  start: 15,
                    end: 15, */
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
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 15.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              return GetDialogs.orderSortDialog(
                                  context, update);
                            },
                            child: Icon(
                              Icons.swap_vert,
                              color: white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 15.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              return GetDialogs.filterDialog(context, update);
                            },
                            child: Icon(
                              Icons.tune,
                              color: white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
