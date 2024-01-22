import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Provider/UserProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Provider/SettingsProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/appBar.dart';
import '../../Widget/dashedRect.dart';
import '../../Widget/desing.dart';
import '../../Widget/jwtkeySecurity.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/setSnackbar.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateProfile();
}

String? lat, long;

class StateProfile extends State<Profile> with TickerProviderStateMixin {
  String? name, email, mobile, curPass, newPass, confPass;

  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController? nameC, mobileC, curPassC, newPassC, confPassC;
  bool _showCurPassword = false, _showPassword = false, _showCmPassword = false;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  SettingProvider? settingProvider;
  List<File> licenseImages = [];
  List<String> licenseGetImages = [];

  @override
  void initState() {
    super.initState();
    settingProvider = Provider.of<SettingProvider>(context, listen: false);
    mobileC = new TextEditingController();
    nameC = new TextEditingController();

    getUserDetails();

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
    mobileC?.dispose();
    nameC?.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  getUserDetails() async {
    CUR_USERID = await settingProvider!.getPrefrence(ID);
    mobile = await settingProvider!.getPrefrence(MOBILE);
    name = await settingProvider!.getPrefrence(USERNAME);
    email = await settingProvider!.getPrefrence(EMAIL);
    mobileC!.text = mobile!;
    nameC!.text = name!;
    licenseGetImages =
        await settingProvider!.getListPrefrence(DRIVING_LICENSE) ?? [];
    setState(
      () {},
    );
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context
            .read<UserProvider>()
            .updateUserProfile(
                userID: CUR_USERID!,
                username: name,
                userEmail: email,
                newPassword: newPass != null && newPass != "" ? newPass : null,
                oldPassword: curPass != null && curPass != "" ? curPass : null)
            .then(
          (
            value,
          ) async {
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              setSnackbar(msg!, context);
              CUR_USERNAME = name;
              settingProvider!
                  .saveUserDetail(CUR_USERID!, name!, email!, mobile!, context);
            } else {
              setSnackbar(msg!, context);
            }
          },
        ),
      );
    } else {
      setState(
        () {
          isNetworkAvail = false;
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> setDrivingLicense(List<File> image) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      setState(() {
        _isLoading = true;
      });
      try {
        var request = MultipartRequest("POST", getUpdateUserApi);
        request.headers.addAll(headers);
        request.fields[USER_ID] = CUR_USERID!;
        if (licenseImages.isNotEmpty) {
          for (var i = 0; i < licenseImages.length; i++) {
            var pic = await MultipartFile.fromPath(
              DRIVING_LICENSE_OTHER,
              licenseImages[i].path,
            );

            request.files.add(pic);
          }
        }
        print("request field****${request.fields}****${request.files}");

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var getdata = json.decode(responseString);
        print("getdata******$getdata*******${response.statusCode}");
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {
          CUR_DRIVING_LICENSE = getdata[DRIVING_LICENSE];
          settingProvider!
              .setListPrefrence(DRIVING_LICENSE, CUR_DRIVING_LICENSE);
        }
        setSnackbar(msg!, context);

        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg, context);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        isNetworkAvail = false;
      });
    }
  }

  setUser() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.person_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NAME_LBL,
                  style: Theme.of(this.context).textTheme.bodySmall!.copyWith(
                        color: lightBlack2,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                name != "" && name != null
                    ? Text(
                        name!,
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container()
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: lightBlack,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          circularBorderRadius5,
                        ),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                          child: Text(
                            getTranslated(context, ADD_NAME_LBL)!,
                            style: Theme.of(this.context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: primary,
                                ),
                          ),
                        ),
                        Divider(
                          color: lightBlack,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: (val) =>
                                  StringValidation.validateUserName(
                                val,
                                context,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: nameC,
                              onChanged: (v) => setState(
                                () {
                                  name = v;
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: Text(
                          getTranslated(context, CANCEL)!,
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: textFontSize15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      new TextButton(
                        child: Text(
                          getTranslated(context, SAVE_LBL)!,
                          style: TextStyle(
                            color: primary,
                            fontSize: textFontSize15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(
                              () {
                                name = nameC!.text;
                                Navigator.pop(context);
                              },
                            );
                            checkNetwork();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.phone_in_talk_rounded,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, MOBILEHINT_LBL)!,
                  style: Theme.of(this.context).textTheme.bodySmall!.copyWith(
                        color: lightBlack2,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                mobile != null && mobile != ""
                    ? Text(
                        mobile!,
                        style: Theme.of(this.context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  changePass() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 15,
        right: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        height: 60,
        width: deviceWidth,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                circularBorderRadius10,
              ),
            ),
          ),
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                top: 15.0,
                bottom: 15.0,
              ),
              child: Text(
                getTranslated(context, CHANGE_PASS_LBL)!,
                style: Theme.of(this.context).textTheme.titleSmall!.copyWith(
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            onTap: () {
              _showDialog();
            },
          ),
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
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
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                      child: Text(
                        getTranslated(context, CHANGE_PASS_LBL)!,
                        style: Theme.of(this.context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: primary,
                            ),
                      ),
                    ),
                    Divider(
                      color: lightBlack,
                    ),
                    Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (val) => StringValidation.validatePass(
                                  val, context,
                                  onlyRequired: false),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  hintText:
                                      getTranslated(context, CUR_PASS_LBL)!,
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showCurPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    iconSize: 20,
                                    color: lightBlack,
                                    onPressed: () {
                                      setStater(
                                        () {
                                          _showCurPassword = !_showCurPassword;
                                        },
                                      );
                                    },
                                  ),
                                  errorMaxLines: 4),
                              obscureText: !_showCurPassword,
                              controller: curPassC,
                              onChanged: (v) => setState(
                                () {
                                  curPass = v;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (val) => StringValidation.validatePass(
                                  val, context,
                                  onlyRequired: false),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: new InputDecoration(
                                  hintText:
                                      getTranslated(context, NEW_PASS_LBL)!,
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    iconSize: 20,
                                    color: lightBlack,
                                    onPressed: () {
                                      setStater(
                                        () {
                                          _showPassword = !_showPassword;
                                        },
                                      );
                                    },
                                  ),
                                  errorMaxLines: 4),
                              obscureText: !_showPassword,
                              controller: newPassC,
                              onChanged: (v) => setState(
                                () {
                                  newPass = v;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.length == 0)
                                  return getTranslated(
                                      context, CON_PASS_REQUIRED_MSG);
                                if (value != newPass) {
                                  return getTranslated(
                                      context, CON_PASS_NOT_MATCH_MSG)!;
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: new InputDecoration(
                                hintText: getTranslated(
                                    context, CONFIRMPASSHINT_LBL)!,
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showCmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  iconSize: 20,
                                  color: lightBlack,
                                  onPressed: () {
                                    setStater(
                                      () {
                                        _showCmPassword = !_showCmPassword;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: !_showCmPassword,
                              controller: confPassC,
                              onChanged: (v) => setState(
                                () {
                                  confPass = v;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child: Text(
                    CANCEL,
                    style:
                        Theme.of(this.context).textTheme.titleSmall!.copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new TextButton(
                  child: Text(
                    SAVE_LBL,
                    style:
                        Theme.of(this.context).textTheme.titleSmall!.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      form.save();
                      setState(
                        () {
                          Navigator.pop(context);
                        },
                      );
                      checkNetwork();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _imgFromGallery() async {
    List<XFile>? pickedFileList = await ImagePicker().pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    licenseImages.clear();
    if (pickedFileList.isNotEmpty) {
      if (pickedFileList.length < 2) {
        setSnackbar(
            getTranslated(context, 'PLZ_ADD_FROND_BACK_IMAGE_MSG')!, context);
      } else if (pickedFileList.length > 2) {
        setSnackbar(getTranslated(context, 'ADD_ONLY_TWO_IMAGES')!, context);
      } else {
        licenseGetImages.clear();
        for (int i = 0; i < pickedFileList.length; i++) {
          licenseImages.add(File(pickedFileList[i].path));
        }

        await setDrivingLicense(licenseImages);

        setState(() {});
      }
    }
  }
  Widget getDrivingLicense() {
    print("license get images*****${licenseGetImages.length}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/PNG/drivinglicense.png',
            height: 23,
            width: 23,
            fit: BoxFit.fill,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getTranslated(context, 'DRIVING_LICENSE_LBL')!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: lightBlack2,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  height: 110, // Adjust the height according to your needs
                  child: licenseGetImages.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: licenseGetImages.length,
                          itemBuilder: (context, index) {
                            // Build your list item widgets here
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: index != 0 ? 10 : 0),
                              child: InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FadeInImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 150),
                                      image:
                                          NetworkImage(licenseGetImages[index]),
                                      height: 100.0,
                                      fit: BoxFit.fill,
                                      width: deviceWidth! / 2.7,
                                      placeholder:
                                          DesignConfiguration.placeHolder(90),
                                      imageErrorBuilder:
                                          ((context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/PNG/placeholder.png',
                                          height: 90,
                                          width: 90,
                                        );
                                      }),
                                      placeholderErrorBuilder:
                                          ((context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/PNG/placeholder.png',
                                          height: 90,
                                          width: 90,
                                        );
                                      })),
                                ),
                                onTap: () {
                                  _imgFromGallery();
                                },
                              ),
                            ); // Widget for each list item
                          },
                        )
                      : uploadOtherImage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget uploadOtherImage() {
    return licenseImages.isEmpty
        ? InkWell(
            onTap: () {
              _imgFromGallery();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 110,
                  width: deviceWidth! / 2.7,
                  child: DashedRect(
                    color: lightBlack,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 12,
                            color: lightBlack,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Expanded(
                              child: Text(
                                getTranslated(context, 'FRONT_SIDE_IMAGE_LBL')!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: lightBlack),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 110,
                  width: deviceWidth! / 2.7,
                  child: DashedRect(
                    color: lightBlack,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 12,
                            color: lightBlack,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Expanded(
                              child: Text(
                                getTranslated(context, 'BACK_SIDE_IMAGE_LBL')!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: lightBlack),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              _imgFromGallery();
            },
            child: SizedBox(
                height: 110,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: licenseImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: index != 0 ? 10 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          licenseImages[index],
                          height: 100.0,
                          fit: BoxFit.fill,
                          width: deviceWidth! / 2.7,
                        ),
                      ),
                    );
                  },
                )),
          );
  }

  profileImage() {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 30.0,
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: primary,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(circularBorderRadius100),
            border: Border.all(color: primary),
          ),
          child: Icon(Icons.account_circle, size: 100),
        ),
      ),
    );
  }

  _getDivider() {
    return Divider(
      height: 1,
      color: lightBlack,
    );
  }

  _showContent1() {
    return SingleChildScrollView(
      child: isNetworkAvail
          ? Column(
              children: <Widget>[
                GradientAppBar(
                  getTranslated(context, EDIT_PROFILE_LBL)!,
                ),
                profileImage(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 10.0,
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(circularBorderRadius5)),
                      boxShadow: const [
                        BoxShadow(
                          color: blarColor,
                          offset: Offset(0, 0),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                      color: white,
                    ),
                    child: Column(
                      children: <Widget>[
                        setUser(),
                        _getDivider(),
                        setMobileNo(),
                        _getDivider(),
                        getDrivingLicense(),
                      ],
                    ),
                  ),
                ),
                changePass()
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      // appBar: getAppBar(
      //   getTranslated(context, EDIT_PROFILE_LBL)!,
      //   context,
      // ),

      body: Stack(
        children: <Widget>[
          _showContent1(),
          DesignConfiguration.showCircularProgress(_isLoading, primary)
        ],
      ),
    );
  }
}
