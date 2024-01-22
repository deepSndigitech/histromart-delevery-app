import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/setSnackbar.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class ShippingDetails extends StatelessWidget {
  Order_Model model;
  ShippingDetails({
    Key? key,
    required this.model,
  }) : super(key: key);

  void _launchCaller(
    String phoneNumber,
    BuildContext context,
  ) async {
    var url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      setSnackbar('Could not launch $url', context);
      throw 'Could not launch $url';
    }
  }

  _launchMap(lat, lng) async {
    var url = '';
    if (Platform.isAndroid) {
      url =
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate";
    } else {
      url =
          "http://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving&dir_action=navigate";
    }
    print("url string : ${url}");
    print("uri : ${Uri.parse(url)}");
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
          boxShadow: const [
            BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    getTranslated(context, SHIPPING_DETAIL)!,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize13,
                        ),
                  ),
                  const Spacer(),
                  model.latitude != "" && model.longitude != ""
                      ? SizedBox(
                          height: 30,
                          child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: primary,
                            ),
                            onPressed: () {
                              _launchMap(
                                model.latitude,
                                model.longitude,
                              );
                            },
                          ),
                        )
                      : Container()
                ],
              ),
              const Divider(
                color: grey3,
              ),
              Text(
                model.name!.isNotEmpty
                    ? "${StringValidation.capitalize(model.orderRecipientName!)}"
                    : " ",
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "PlusJakartaSans",
                  fontStyle: FontStyle.normal,
                  fontSize: textFontSize13,
                ),
              ),
              Text(
                StringValidation.capitalize(
                  model.address!,
                ),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: grey3,
                  fontSize: textFontSize13,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      Icons.call,
                      size: 15,
                      color: primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${model.mobile!}",
                      style: const TextStyle(
                        color: primary,
                        fontFamily: 'PlusJakartaSans',
                        fontSize: textFontSize13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _launchCaller(model.mobile!, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
