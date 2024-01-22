import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../Helper/color.dart';
import '../Helper/constant.dart';
import 'parameterString.dart';

class DesignConfiguration {
  static setSvgPath(String name) {
    return 'assets/images/SVG/$name.svg';
  }

  static setPngPath(String name) {
    return 'assets/images/PNG/$name.png';
  }

  static setLottiePath(String name) {
    return 'assets/animation/$name.json';
  }

  static placeHolder(double height) {
    return AssetImage(
      DesignConfiguration.setPngPath('placeholder'),
    );
  }

  static String? getPriceFormat(BuildContext context, double price) {
    return NumberFormat.currency(
      locale: Platform.localeName,
      name: "$supportedLocale",
      symbol: "$CUR_CURRENCY",
      decimalDigits: DECIMAL_POINTS == null || DECIMAL_POINTS == ''
          ? 2
          : int.parse(DECIMAL_POINTS!),
    ).format(price).toString();
  }

// progress
  static Widget showCircularProgress(bool _isProgress, Color color) {
    if (_isProgress) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

// Container Decoration
  static back() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [grad1Color, grad2Color],
        stops: [0, 1],
      ),
    );
  }

  static erroWidget(double size) {
    return Image.asset(
      DesignConfiguration.setPngPath('placeholder'),
      height: size,
      width: size,
    );
  }

  static getCacheNotworkImage({
    required String imageurlString,
    required BuildContext context,
    required BoxFit? boxFit,
    required double? heightvalue,
    required double? widthvalue,
    required double? placeHolderSize,
  }) {
    return FadeInImage.assetNetwork(
      image: imageurlString,
      placeholder: DesignConfiguration.setPngPath('placeholder'),
      width: widthvalue,
      height: heightvalue,
      fit: boxFit,
      fadeInDuration: const Duration(
        milliseconds: 150,
      ),
      fadeOutDuration: const Duration(
        milliseconds: 150,
      ),
      fadeInCurve: Curves.linear,
      fadeOutCurve: Curves.linear,
      imageErrorBuilder: (context, error, stackTrace) {
        return Container(
          child: DesignConfiguration.erroWidget(placeHolderSize ?? 50),
        );
      },
    );

    CachedNetworkImage(
      imageUrl: imageurlString,
      placeholder: (context, url) {
        return DesignConfiguration.erroWidget(placeHolderSize ?? 50);
      },
      errorWidget: (context, error, stackTrace) {
        return Container(
          child: DesignConfiguration.erroWidget(placeHolderSize ?? 50),
        );
      },
      fadeInCurve: Curves.linear,
      fadeOutCurve: Curves.linear,
      fadeInDuration: const Duration(
        milliseconds: 150,
      ),
      fadeOutDuration: const Duration(
        milliseconds: 150,
      ),
      fit: boxFit,
      height: heightvalue,
      width: widthvalue,
    );
  }

// Container Decoration
  static shadow() {
    return const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(0, 0),
          blurRadius: 30,
        ),
      ],
    );
  }
}
