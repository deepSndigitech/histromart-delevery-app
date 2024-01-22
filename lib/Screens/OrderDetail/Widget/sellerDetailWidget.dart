import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/setSnackbar.dart';
import '../../../Widget/validation.dart';

class SellerDetails extends StatelessWidget {
  Order_Model model;
  int index;
  SellerDetails({
    Key? key,
    required this.model,
    required this.index,
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
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5.0, 0, 5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(circularBorderRadius10),
              child: DesignConfiguration.getCacheNotworkImage(
                boxFit: BoxFit.cover,
                context: context,
                heightvalue: 50,
                widthvalue: 50,
                imageurlString: model.itemList![index].storeImage!,
                placeHolderSize: 150,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Text(
                      model.itemList![index].storeName != "" &&
                              model.itemList![index].storeName!.isNotEmpty
                          ? "${StringValidation.capitalize(model.itemList![index].storeName!)}"
                          : " ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 1,
                          ),
                          child: Text(
                            StringValidation.capitalize(
                                model.itemList![index].sellerAddress!),
                            style: const TextStyle(
                              color: lightBlack2,
                            ),
                          ),
                        ),
                      ),
                      model.itemList![index].storeLatitude != "" &&
                              model.itemList![index].storeLongitude != ""
                          ? Container(
                              height: 25,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.location_on,
                                  color: primary,
                                  size: 15,
                                ),
                                onPressed: () {
                                  _launchMap(
                                      model.itemList![index].storeLatitude,
                                      model.itemList![index].storeLongitude);
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 1,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 15,
                            color: primary,
                          ),
                          SizedBox(
                            width: 05,
                          ),
                          Text(
                            "${model.itemList![index].sellerMobileNumber!}",
                            style: const TextStyle(
                              color: primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _launchCaller(
                        model.itemList![index].sellerMobileNumber!,
                        context,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
