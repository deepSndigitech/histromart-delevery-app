import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Screens/Authentication/SignUp/sign_up.dart';
import 'package:deliveryboy_multivendor/Screens/Privacy%20policy/privacy_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../Helper/constant.dart';
import '../../../Provider/AuthProvider.dart';
import '../../../Provider/SettingsProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../../Widget/ButtonDesing.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/networkAvailablity.dart';
import '../../../Widget/noNetwork.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/setSnackbar.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../DeshBord/deshBord.dart';
import '../send_otp.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController(text: "1234567890");
  final passwordController = TextEditingController(text: "12345678");
/*  final mobileController = TextEditingController(text: "8264644413");
  final passwordController = TextEditingController(text: "12345678");*/

  FocusNode? passFocus, monoFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//  String? password, mobile;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool isShowPass = true;
  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.8,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context.read<AuthenticationProvider>().getLoginData().then(
          (
            value,
          ) async {
            print("value****$value");
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              var getdata = value['data'][0];
              UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);

              userProvider.setName(getdata[USERNAME] ?? '');
              userProvider.setEmail(getdata[EMAIL] ?? '');
              userProvider.setUserId(getdata[ID] ?? '');
              userProvider.setMobile(getdata[MOBILE] ?? '');
              userProvider.setProfilePic(getdata[IMAGE] ?? '');

              SettingProvider settingProvider =
                  Provider.of<SettingProvider>(context, listen: false);
              settingProvider.saveUserDetail(
                getdata[ID],
                getdata[USERNAME],
                getdata[EMAIL],
                getdata[MOBILE],
                context,
              );
              setPrefrenceBool(isLogin, true);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            } else {
              setSnackbar(msg!, context);
            }
          },
        ),
      );
    } else {
      Future.delayed(Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              isNetworkAvail = false;
            },
          );
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

  signInSubTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 13.0,
      ),
      child: Text(
        'Please enter your login details below to start using app.',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.38),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  Widget signInTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Text(
        "Welcome to eShop DeliveryBoy",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize20,
              letterSpacing: 0.8,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  Widget termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
        left: 25.0,
        right: 25.0,
        top: 10.0,
      ),
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
    );
  }

  Widget setMobileNo() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          onFieldSubmitted: (v) {
            FocusScope.of(context).requestFocus(passFocus);
          },
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          keyboardType: TextInputType.number,
          controller: mobileController,
          focusNode: monoFocus,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 5,
              ),
              hintText: getTranslated(context, MOBILEHINT_LBL)!,
              hintStyle: TextStyle(
                  color: black.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize13),
              fillColor: lightWhite,
              border: InputBorder.none),
          validator: (val) => StringValidation.validateMob(val, context),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setMobileNumber(value);
          },
        ),
      ),
    );
  }

  Widget setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        height: 53,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lightWhite,
          borderRadius: BorderRadius.circular(circularBorderRadius10),
        ),
        alignment: Alignment.center,
        child: TextFormField(
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: textFontSize13),
          onFieldSubmitted: (v) {
            passFocus!.unfocus();
          },
          keyboardType: TextInputType.text,
          obscureText: isShowPass,
          controller: passwordController,
          focusNode: passFocus,
          textInputAction: TextInputAction.next,
          validator: (val) =>
              StringValidation.validatePass(val, context, onlyRequired: true),
          onSaved: (String? value) {
            context.read<AuthenticationProvider>().setPassword(value);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 5,
            ),
            errorMaxLines: 4,
            suffixIcon: InkWell(
              onTap: () {
                setState(
                  () {
                    isShowPass = !isShowPass;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: Icon(
                  !isShowPass ? Icons.visibility : Icons.visibility_off,
                  color: fontColor.withOpacity(0.4),
                  size: 22,
                ),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, maxHeight: 20),
            hintText: getTranslated(context, PASSHINT_LBL)!,
            hintStyle: TextStyle(
                color: fontColor.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: textFontSize13),
            fillColor: lightWhite,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget forgetPass() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SendOtp(
                    title: getTranslated(context, FORGOT_PASS_TITLE),
                  ),
                ),
              );
            },
            child: Text(
              getTranslated(context, FORGOT_PASSWORD_LBL)!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: textFontSize13,
                    fontFamily: 'ubuntu',
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            return AppBtn(
              title: getTranslated(context, SIGNIN_LBL)!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                validateAndSubmit();
              },
            );
          },
        ),
      ),
    );
  }

  Widget signUpBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            return TextButton(
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: getTranslated(context, "DON'T_HAVE_AN_ACC_LBL")!,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                            text: getTranslated(context,'SIGN_UP_LBL'),
                            style: TextStyle(
                                color: primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ]),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignUp(),
                    ));
              },
            );
          },
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
          ? SingleChildScrollView(
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
                    signInTxt(),
                    signInSubTxt(),
                    setMobileNo(),
                    setPass(),
                    forgetPass(),
                    loginBtn(),
                    signUpBtn(),
                    termAndPolicyTxt(),
                  ],
                ),
              ),
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  forgotpassTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: black,
                fontWeight: FontWeight.bold,
                fontSize: textFontSize23,
                letterSpacing: 0.8,
                fontFamily: 'ubuntu',
              ),
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
