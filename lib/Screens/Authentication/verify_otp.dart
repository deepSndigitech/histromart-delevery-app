import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Helper/constant.dart';
import '../../Provider/SettingsProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/ContainerDesing.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/scrollBehavior.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'set_password.dart';

class VerifyOtp extends StatefulWidget {
  final String? mobileNumber, countryCode, title;

  VerifyOtp(
      {Key? key,
      required String this.mobileNumber,
      this.countryCode,
      this.title})
      : super(key: key);

  @override
  _MobileOTPState createState() => _MobileOTPState();
}

class _MobileOTPState extends State<VerifyOtp> with TickerProviderStateMixin {
  final dataKey = GlobalKey();

  String? otp;
  bool isCodeSent = false;
  late String _verificationId;
  String signature = "";
  bool _isClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  @override
  void initState() {
    super.initState();
    getSingature();
    _onVerifyCode();
    Future.delayed(Duration(seconds: 60)).then(
      (_) {
        _isClickable = true;
      },
    );
    buttonController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
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

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    await SmsAutoFill().listenForCode;
  }

  Future<void> checkNetworkOtp() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      if (_isClickable) {
        _onVerifyCode();
      } else {
        setSnackbar(OTPWR, context);
      }
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );

      Future.delayed(Duration(seconds: 60)).then(
        (_) async {
          isNetworkAvail = await isNetworkAvailable();
          if (isNetworkAvail) {
            if (_isClickable)
              _onVerifyCode();
            else {
              setSnackbar(getTranslated(context, OTPWR)!, context);
            }
          } else {
            await buttonController!.reverse();
            setSnackbar(somethingMSg, context);
          }
        },
      );
    }
  }

  verifyBtn() {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        child: AppBtn(
          title: getTranslated(context, VERIFY_AND_PROCEED),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            _onFormSubmitted();
          },
        ),
      ),
    );
  }

  void _onVerifyCode() async {
    setState(
      () {
        isCodeSent = true;
      },
    );
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          setSnackbar(getTranslated(context, OTPMSG)!, context);
          SettingProvider settingProvider =
              Provider.of<SettingProvider>(context, listen: false);

          settingProvider.setPrefrence(MOBILE, widget.mobileNumber!);
          settingProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);

          if (widget.title == getTranslated(context, FORGOT_PASS_TITLE)) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => SetPass(
                  mobileNumber: widget.mobileNumber!,
                ),
              ),
            );
          }
        } else {
          setSnackbar(getTranslated(context, OTPERROR)!, context);
        }
      }).catchError(
        (error) {
          setSnackbar(error.toString(), context);
        },
      );
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setSnackbar(authException.message!, context);

      setState(
        () {
          isCodeSent = false;
        },
      );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      setState(
        () {
          _verificationId = verificationId;
        },
      );
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(
        () {
          _isClickable = true;
          _verificationId = verificationId;
        },
      );
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+${widget.countryCode}${widget.mobileNumber}",
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void _onFormSubmitted() async {
    String code = otp!.trim();

    if (code.length == 6) {
      _playAnimation();
      AuthCredential _authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      _firebaseAuth.signInWithCredential(_authCredential).then(
        (UserCredential value) async {
          if (value.user != null) {
            await buttonController!.reverse();
            setSnackbar(OTPMSG, context);
            SettingProvider settingProvider =
                Provider.of<SettingProvider>(context, listen: false);

            settingProvider.setPrefrence(MOBILE, widget.mobileNumber!);
            settingProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);
            if (widget.title == getTranslated(context, SEND_OTP_TITLE)) {
            } else if (widget.title ==
                getTranslated(context, FORGOT_PASS_TITLE)) {
              Future.delayed(Duration(seconds: 2)).then(
                (_) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SetPass(
                        mobileNumber: widget.mobileNumber!,
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            setSnackbar(
              getTranslated(context, OTPERROR)!,
              context,
            );
            await buttonController!.reverse();
          }
        },
      ).catchError(
        (error) async {
          setSnackbar(error.toString(), context);

          await buttonController!.reverse();
        },
      );
    } else {
      setSnackbar(
        getTranslated(context, ENTEROTP)!,
        context,
      );
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  getImage() {
    return Expanded(
      flex: 4,
      child: Center(
        child: Image.asset(
          DesignConfiguration.setPngPath('splashlogo'),
          color: primary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Widget monoVarifyText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 60.0,
      ),
      child: Text(
        getTranslated(context, MOBILE_NUMBER_VARIFICATION)!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              letterSpacing: 0.8,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  Widget otpText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 13.0,
      ),
      child: Text(
        getTranslated(context, SENT_VERIFY_CODE_TO_NO_LBL)!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  Widget mobText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 5.0),
      child: Text(
        '+${widget.countryCode}-${widget.mobileNumber}',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'ubuntu',
            ),
      ),
    );
  }

  Widget otpLayout() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30),
      child: PinFieldAutoFill(
        decoration: BoxLooseDecoration(
            textStyle: TextStyle(fontSize: textFontSize20, color: black),
            radius: Radius.circular(circularBorderRadius5),
            gapSpace: 15,
            bgColorBuilder: FixedColorBuilder(lightWhite.withOpacity(0.4)),
            strokeColorBuilder: FixedColorBuilder(black.withOpacity(0.2))),
        currentCode: otp,
        codeLength: 6,
        onCodeChanged: (String? code) {
          otp = code;
        },
        onCodeSubmitted: (String code) {
          otp = code;
        },
      ),
    );
  }

  Widget resendText() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 30.0),
      child: Row(
        children: [
          Text(
            getTranslated(context, DIDNT_GET_THE_CODE)!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: black.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ubuntu',
                ),
          ),
          InkWell(
            onTap: () async {
              await buttonController!.reverse();
              checkNetworkOtp();
            },
            child: Text(
              RESEND_OTP,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ubuntu',
                  ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 23,
              left: 23,
              right: 23,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getLogo(),
                monoVarifyText(),
                otpText(),
                mobText(),
                otpLayout(),
                resendText(),
                verifyBtn(),
              ],
            ),
          ),
        ),
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
                      monoVarifyText(),
                      otpText(),
                      mobText(),
                      otpLayout(),
                      verifyBtn(),
                      resendText(),
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
