import 'dart:async';
import 'dart:io';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'Login/LoginScreen.dart';

class SetPass extends StatefulWidget {
  final String mobileNumber;

  SetPass({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SetPass> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final confirmpassController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? password, comfirmpass;
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;

  AnimationController? buttonController;

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
        (value) => context.read<AuthenticationProvider>().getReset().then(
          (
            value,
          ) async {
            print("value*****$value");
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              setSnackbar(getTranslated(context, PASS_SUCCESS_MSG)!, context);
              Future.delayed(Duration(seconds: 1)).then(
                (_) {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => Login(),
                    ),
                  );
                },
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
          setState(
            () {
              _isNetworkAvail = false;
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

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        _isNetworkAvail = await isNetworkAvailable();
        if (_isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
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

  subLogo() {
    return Expanded(
      child: Center(
        child: Image.asset(
          DesignConfiguration.setPngPath('splashlogo'),
          color: primary,
        ),
      ),
    );
  }

  Widget forgotpassTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          getTranslated(context, 'Set Password')!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: black,
                fontWeight: FontWeight.bold,
                fontSize: 23,
                letterSpacing: 0.8,
                fontFamily: 'ubuntu',
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Widget setPass() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: TextFormField(
        style: TextStyle(
            color: black.withOpacity(0.7),
            fontWeight: FontWeight.bold,
            fontSize: textFontSize13),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            StringValidation.validatePass(val, context, onlyRequired: false),
        onSaved: (String? value) {
          context.read<AuthenticationProvider>().setNewPassword(value);
          password = value;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          hintText: getTranslated(context, PASSHINT_LBL),
          hintStyle: TextStyle(
              color: black.withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: 13),
          errorMaxLines: 4,
          fillColor: lightWhite,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(circularBorderRadius10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget setConfirmpss() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child:  TextFormField(
          style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 13),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: confirmpassController,
          validator: (value) {
            if (value!.isEmpty)
              return getTranslated(context, CON_PASS_REQUIRED_MSG);
            if (value != password) {
              return getTranslated(context, CON_PASS_NOT_MATCH_MSG);
            } else {
              return null;
            }
          },
          onSaved: (String? value) {
            comfirmpass = value;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 5,
            ),
            hintText: getTranslated(
              context,
              CONFIRMPASSHINT_LBL,
            ),
            hintStyle: TextStyle(
                color: black.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: 13),
            fillColor: lightWhite,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(circularBorderRadius10),
                borderSide: BorderSide.none),
          ),
        ),

    );
  }

  backBtn() {
    return Platform.isIOS
        ? Container(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: InkWell(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: primary,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

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

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setPassBtn() {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        child: AppBtn(
          title: getTranslated(context, SET_PASSWORD),
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: _isNetworkAvail
          ? Center(
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
                      forgotpassTxt(),
                      setPass(),
                      setConfirmpss(),
                      setPassBtn(),
                    ],
                  ),
                ),
              ),
            )

          // Container(
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
                      forgotpassTxt(),
                      setPass(),
                      setConfirmpss(),
                      setPassBtn(),
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
