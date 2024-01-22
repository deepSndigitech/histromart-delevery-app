import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Provider/SystemProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';

class PrivacyPolicy extends StatefulWidget {
  final String? title;

  const PrivacyPolicy({Key? key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatePrivacy();
  }
}

class StatePrivacy extends State<PrivacyPolicy> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  @override
  void initState() {
    super.initState();
    getSystemPolicy();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isNetworkAvail
          ? Consumer<SystemProvider>(builder: (context, value, child) {
              if (value.getCurrentStatus ==
                  SystemProviderPolicyStatus.isSuccsess) {
                if (value.policy.isNotEmpty) {
                  return Column(
                    children: [
                      GradientAppBar(
                        widget.title!,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: WebViewWidget(
                              controller: WebViewController()
                                ..enableZoom(true)
                                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                ..loadHtmlString(value.policy)),
                        ),
                      ),
                    ],
                  );
                } else {
                  Column(
                    children: [
                      GradientAppBar(
                        widget.title!,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            getTranslated(context, 'No Data Found')!,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else if (value.getCurrentStatus ==
                  SystemProviderPolicyStatus.isFailure) {
                return Column(
                  children: [
                    GradientAppBar(
                      widget.title!,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                            'Something went wrong:- ${value.errorMessage}'),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  GradientAppBar(
                    widget.title!,
                  ),
                  Expanded(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            })
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Future<void> getSystemPolicy() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      String type = '';
      if (widget.title == getTranslated(context, PRIVACY)) {
        type = PRIVACY_POLLICY;
      } else if (widget.title == getTranslated(context, TERM)) {
        type = TERM_COND;
      }

      await Future.delayed(Duration.zero);
      await context.read<SystemProvider>().getSystemPolicies(type);
    }
  }
}
