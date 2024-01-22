import 'package:deliveryboy_multivendor/Model/order_model.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../order_detail.dart';

class GetOtpDailog {
  static otpDialog(
    String? curSelected,
    String? otp,
    String? id,
    bool item,
    int index,
    BuildContext context,
    Order_Model model,
    Function update,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext cxt1) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
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
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                      child: Text(
                        getTranslated(ctx, OTP_LBL)!,
                        style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                              color: fontColor,
                            ),
                      ),
                    ),
                    const Divider(color: lightBlack),
                    Form(
                      key: orderDetailProvider!.formkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(ctx, FIELD_REQUIRED)!;
                                } else if (value.trim() != otp) {
                                  return getTranslated(ctx, OTPERROR);
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: getTranslated(ctx, OTP_ENTER)!,
                                hintStyle: Theme.of(ctx)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: orderDetailProvider!.otpC,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(ctx, CANCEL)!,
                    style: Theme.of(ctx).textTheme.titleSmall!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(ctx, SEND_LBL)!,
                    style: Theme.of(ctx).textTheme.titleSmall!.copyWith(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    final form = orderDetailProvider!.formkey.currentState!;
                    if (form.validate()) {
                      form.save();
                      Navigator.pop(ctx);
                      update();
                      orderDetailProvider!.updateOrder(
                        curSelected,
                        id,
                        item,
                        index,
                        otp,
                        update,
                        context,
                        model,
                      );
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
