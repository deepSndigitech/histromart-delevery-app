import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Provider/AuthProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/ContainerDesing.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/scrollBehavior.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import '../Privacy policy/privacy_policy.dart';
import 'verify_otp.dart';

class SendOtp extends StatefulWidget {
  final String? title;

  SendOtp({Key? key, this.title}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, countrycode, countryName;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) =>
            context.read<AuthenticationProvider>().getVerifyUser(mobile!).then(
          (
            value,
          ) async {
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              if (widget.title == getTranslated(context, SEND_OTP_TITLE)) {
                if (!error) {
                  setSnackbar(msg!, context);
                  Future.delayed(Duration(seconds: 1)).then(
                    (_) {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => VerifyOtp(
                            mobileNumber: mobile!,
                            countryCode: countrycode,
                            title: getTranslated(context, SEND_OTP_TITLE),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  setSnackbar(msg!, context);
                }
              }
              if (widget.title == getTranslated(context, FORGOT_PASS_TITLE)) {
                if (!error) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => VerifyOtp(
                        mobileNumber: mobile!,
                        countryCode: countrycode,
                        title: getTranslated(context, FORGOT_PASS_TITLE),
                      ),
                    ),
                  );
                } else {
                  setSnackbar(msg!, context);
                }
              }
            } else {
              setSnackbar(msg!, context);
            }
          },
        ),
      );
    } else {
      Future.delayed(Duration(seconds: 1)).then(
        (_) async {
          setState(
            () {
              isNetworkAvail = false;
            },
          );
          await buttonController!.reverse();
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  createAccTxt() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.title == getTranslated(context, SEND_OTP_TITLE)
              ? getTranslated(context, CREATE_ACC_LBL)!
              : getTranslated(context, FORGOT_PASSWORDTITILE)!,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  verifyCodeTxt() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Text(
        getTranslated(context, SEND_VERIFY_CODE_LBL)!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.4),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 3,
      ),
    );
  }

  setCodeWithMono() {
    return Padding(
        padding: const EdgeInsets.only(top: 45),
        child: IntlPhoneField(
          controller: mobileController,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: black, fontWeight: FontWeight.normal),

          decoration: InputDecoration(
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: black, fontWeight: FontWeight.normal),
            hintText: getTranslated(context, MOBILEHINT_LBL),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(circularBorderRadius10)),
            fillColor: lightWhite,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          validator: (val) => StringValidation.validateMobIntl(val!, context),
          initialCountryCode: defaultCountryCode,
          onTap: () {},
          onSaved: (phoneNumber) {
            setState(() {
              countrycode =
                  phoneNumber!.countryCode.toString().replaceFirst('+', '');
              mobile = phoneNumber.number;
            });
          },
          onCountryChanged: (country) {
            setState(() {
              countrycode = country.dialCode;
            });
          },
          onChanged: (phone) {},
          //disableLengthCheck: true,
          autovalidateMode: AutovalidateMode.always,
          autofocus: true,
          showDropdownIcon: false,
          //invalidNumberMessage:getTranslated(context, VALID_MOB)!,
          keyboardType: TextInputType.number,
          flagsButtonMargin: const EdgeInsets.only(left: 20, right: 20),
          // flagsButtonPadding:const EdgeInsets.only(right: 20) ,
          pickerDialogStyle: PickerDialogStyle(
            padding: const EdgeInsets.only(left: 10, right: 10),
          ),
        ) /*Container(
          height: 53,
          alignment: Alignment.center,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: lightWhite,
            borderRadius: BorderRadius.circular(circularBorderRadius10),
          ),
          child:
              setContryCode() */ /* Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: setContryCode(),
            ),
            Expanded(
              flex: 4,
              child: setMono(),
            )
          ],
        ),*/ /*
          ),*/
        );
    /* SizedBox(
      width: width * 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularBorderRadius7),
          color: lightWhite,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: setContryCode(),
            ),
            Expanded(
              flex: 4,
              child: setMono(),
            )
          ],
        ),
      ),
    );*/
  }

/*  setCodeWithMono() {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: setCountryCode(),
            ),
            Expanded(
              flex: 4,
              child: setMono(),
            )
          ],
        ),
      ),
    );
  }

  Widget setCountryCode() {
    double width = deviceWidth!;
    double height = deviceHeight * 0.8;
    return CountryCodePicker(
      showCountryOnly: false,
      searchStyle: TextStyle(
        color: black,
      ),
      flagWidth: 20,
      boxDecoration: BoxDecoration(
        color: white,
      ),
      searchDecoration: InputDecoration(
        hintText: getTranslated(context, 'COUNTRY_CODE_LBL'),
        hintStyle: TextStyle(color: black),
        fillColor: black,
      ),
      showOnlyCountryWhenClosed: false,
      initialSelection: defaultCountryCode,
      dialogSize: Size(width, height),
      alignLeft: true,
      textStyle: TextStyle(color: black, fontWeight: FontWeight.bold),
      onChanged: (CountryCode countryCode) {
        countrycode = countryCode.toString().replaceFirst('+', '');
        countryName = countryCode.name;
      },
      onInit: (code) {
        countrycode = code.toString().replaceFirst('+', '');
      },
    );
  }*/

  setMono() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileController,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: black, fontWeight: FontWeight.normal),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (val) => StringValidation.validateMob(val, context),
      onSaved: (String? value) {
        context.read<AuthenticationProvider>().setMobileNumber(value);
        mobile = value;
      },
      decoration: InputDecoration(
        hintText: getTranslated(context, MOBILEHINT_LBL),
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: primary),
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightWhite,
          ),
        ),
      ),
    );
  }

  Widget verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: AppBtn(
          title: widget.title == getTranslated(context, SEND_OTP_TITLE)
              ? getTranslated(context, SEND_OTP)
              : getTranslated(context, GET_PASSWORD),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget termAndPolicyTxt() {
    return widget.title == getTranslated(context, SEND_OTP_TITLE)
        ? Padding(
            padding: const EdgeInsets.only(
                bottom: 30.0, left: 25.0, right: 25.0, top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  getTranslated(context, CONTINUE_AGREE_LBL)!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: fontColor,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(
                              title: getTranslated(context, TERM)!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        getTranslated(context, TERMS_SERVICE_LBL)!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: fontColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      getTranslated(context, AND_LBL)!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: fontColor,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(
                              title: getTranslated(context, PRIVACY)!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        getTranslated(context, PRIVACY)!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: fontColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.8,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: isNetworkAvail
          ? Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 23,
                  left: 23,
                  right: 23,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLogo(),
                      signUpTxt(),
                      verifyCodeTxt(),
                      setCodeWithMono(),
                      verifyBtn(),
                    ],
                  ),
                ),
              ),
            )
          //  Container(
          //     color: lightWhite,
          //     child: Stack(
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           height: double.infinity,
          //           decoration: DesignConfiguration.back(),
          //         ),
          //         Image.asset(
          //           DesignConfiguration.setPngPath('doodle'),
          //           fit: BoxFit.fill,
          //           width: double.infinity,
          //           height: double.infinity,
          //         ),
          //         getLoginContainer(),
          //         getLogo(),
          //       ],
          //     ),
          //   )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Widget getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      top: MediaQuery.of(context).size.height * 0.2, //original
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      createAccTxt(),
                      verifyCodeTxt(),
                      setCodeWithMono(),
                      verifyBtn(),
                      termAndPolicyTxt(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Text(
        getTranslated(context, 'Forgot Password')!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              fontFamily: 'ubuntu',
              letterSpacing: 0.8,
            ),
      ),
    );
  }

  Widget getLogo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 60),
      child: SvgPicture.asset(
        DesignConfiguration.setSvgPath('loginlogo'),
        alignment: Alignment.center,
        height: 90,
        width: 90,
        fit: BoxFit.contain,
      ),
    );
  }
}
