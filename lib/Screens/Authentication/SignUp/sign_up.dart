import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Helper/color.dart';

import '../../../Provider/SettingsProvider.dart';
import '../../../Provider/UserProvider.dart';
import '../../../Provider/signupProvider.dart';
import '../../../Provider/zipcodeListProvider.dart';
import '../../../Widget/ButtonDesing.dart';
import '../../../Widget/api.dart';
import '../../../Widget/dashedRect.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/jwtkeySecurity.dart';
import '../../../Widget/networkAvailablity.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/setSnackbar.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../DeshBord/deshBord.dart';
import '../../Home/home.dart';
import '../Login/LoginScreen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final zipcodesController = TextEditingController();
  final drivingLicenseController = TextEditingController();
  ScrollController controller = new ScrollController();

  bool isZipcodeSelected = false;
  bool licenseImageSelected = false;

  List<String> selectedZipcodeList = [];

  FocusNode? nameFocus,
      mobileFocus,
      emailFocus,
      passFocus,
      confirmPassFocus,
      addressFocus,
      zipcodesFocus,
      licenseFocus;

  List<File> licenseImages = [];

  //List<String> licenseGetImages = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  bool isShowPass = true;
  bool isShowConfirmPass = true;
  String? commaSeperatedSelectedZipcodesList;

  @override
  void initState() {
    super.initState();
    // fetchZipCodes();
    Future.delayed(Duration.zero, () {
      context.read<ZipcodeListProvider>().initalizeVariables();

      controller.addListener(_scrollListener);
      context.read<ZipcodeListProvider>().getZipcode(context, setStateNow);
    });
    //zipcodeLabelController.text = isZipcodeSelected ? 'Your Initial Value' : '';
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

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

  setStateNow() {
    setState(() {});
  }

  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            context.read<ZipcodeListProvider>().loadingMoreNotifier();
          },
        );

        await context
            .read<ZipcodeListProvider>()
            .getZipcode(context, setStateNow);
      }
    }
  }

  Future<void> _playAnimation() async {
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

/*
  bool validateAndSave() {
    final form = _formKey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }*/

  bool validateZipcodes() {
    if (selectedZipcodeList.isEmpty) {
      setSnackbar(getTranslated(context, 'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT')!,
          context);
      return false;
    }
    return true;
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    form.save();
    if (form.validate() && licenseImageSelected && validateZipcodes()) {
      return true;
    } else if (!licenseImageSelected) {
      setSnackbar(getTranslated(context, 'PLZ_SEL_DRIVING_LICENSE_IMAGES_LBL')!,
          context);
    }
    return false;
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      border: InputBorder.none,
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, FocusNode? focusNode,
      String labelText, bool isObscureText,
      {TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      Widget? suffixIcon,
      bool isEnabled = true,
      String? Function(String?)? validator,
      int? maxErrorLines}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isObscureText,
        decoration: buildInputDecoration(labelText).copyWith(
            errorMaxLines: maxErrorLines,
            suffixIcon: suffixIcon,
            fillColor: lightWhite,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        enabled: isEnabled,
        validator: validator == null
            ? (val) {
                if (val == null || val.isEmpty) {
                  return '${getTranslated(context, 'PLZ_ENTER_LBL')} ${labelText.trim()}';
                }

                // You can add custom validation here if needed
                return null;
              }
            : validator,
      ),
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
        for (int i = 0; i < pickedFileList.length; i++) {
          licenseImages.add(File(pickedFileList[i].path));
        }

        setState(() {
          licenseImageSelected = true; // At least one image is selected.
        });
      }
    }
  }

  Widget getDrivingLicense() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: lightWhite),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: lightWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(getTranslated(context, 'DRIVING_LICENSE_LBL')!),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 110, // Adjust the height according to your needs
                child: uploadOtherImage(),
              ),
            ),
          ],
        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          child: Text(
                            getTranslated(context, 'FRONT_SIDE_IMAGE_LBL')!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: lightBlack),
                          ),
                        ),
                      ],
                    ),
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
                          child: Text(
                            getTranslated(context, 'BACK_SIDE_IMAGE_LBL')!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: lightBlack),
                          ),
                        ),
                      ],
                    ),
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
                      start: index != 0 ? 10 : 0,
                    ),
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
              ),
            ),
          );
  }

  getLogo() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10),
      child: SvgPicture.asset(
        DesignConfiguration.setSvgPath('loginlogo'),
        alignment: Alignment.center,
        height: 90,
        width: 90,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    commaSeperatedSelectedZipcodesList = selectedZipcodeList.join(", ");
    print("zipcodes:------------$commaSeperatedSelectedZipcodesList");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 10,
          left: 23,
          right: 23,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              getLogo(),
              SizedBox(height: 15),
              Text(
                getTranslated(context, 'SIGN_UP_LBL')!,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              buildTextField(
                nameController,
                nameFocus,
                getTranslated(context, 'FULL_NAME_LBL')!,
                false,
                validator: (val) => StringValidation.validateUserName(
                  val,
                  context,
                ),
              ),
              buildTextField(
                mobileController,
                mobileFocus,
                getTranslated(context, 'Mobile number')!,
                false,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) => StringValidation.validateMob(val, context),
              ),
              buildTextField(
                emailController,
                emailFocus,
                getTranslated(context, 'EMAIL_LBL')!,
                false,
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    StringValidation.validateEmail(val, context),
              ),
              buildTextField(passwordController, passFocus,
                  getTranslated(context, 'Password')!, isShowPass,
                  validator: (val) => StringValidation.validatePass(
                      val, context,
                      onlyRequired: false),
                  maxErrorLines: 4,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                      child: Icon(
                        !isShowPass ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.4),
                        size: 22,
                      ),
                    ),
                  )),
              buildTextField(
                  confirmPasswordController,
                  confirmPassFocus,
                  getTranslated(context, 'Confirm Password')!,
                  isShowConfirmPass, validator: (value) {
                if (value!.isEmpty) {
                  return getTranslated(context, CON_PASS_REQUIRED_MSG);
                }
                if (value != passwordController.text) {
                  return getTranslated(context, CON_PASS_NOT_MATCH_MSG);
                } else {
                  return null;
                }
              },
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isShowConfirmPass = !isShowConfirmPass;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10.0),
                      child: Icon(
                        !isShowConfirmPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.4),
                        size: 22,
                      ),
                    ),
                  )),
              buildTextField(addressController, addressFocus,
                  getTranslated(context, 'ADDRESS_LBL')!, false),
              setZipcodeContainer(),
              SizedBox(height: 6),
              getDrivingLicense(),
              SizedBox(height: 5),
              Center(
                child: AppBtn(
                  title: getTranslated(context, 'SIGN_UP_LBL')!,
                  btnAnim: buttonSqueezeanimation,
                  btnCntrl: buttonController,
                  onBtnSelected: () async {
                    validateAndSubmit();
                  },
                ),
              ),
              Center(
                child: TextButton(
                  child: RichText(
                    text: TextSpan(
                        text:
                            '${getTranslated(context, 'ALREADY_HAVE_AN_ACC_TXT')!} ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                              text: getTranslated(context, 'LOGIN_LBL')!,
                              style: TextStyle(
                                  color: primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ]),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Login()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setZipcodeContainer() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightWhite),
        child: ListTile(
          title: Text(getTranslated(context, 'SERVICEABLE_ZIPCODE_LBL')!),
          subtitle: isZipcodeSelected
              ? Text(
                  commaSeperatedSelectedZipcodesList!,
                )
              : Text(
                  getTranslated(context, 'PLZ_SEL_AT_LEASE_ONE_ZIPCODES_TXT')!,
                  style: TextStyle(color: Colors.red),
                ),
          trailing: Icon(Icons.arrow_drop_down_sharp),
          onTap: () async {
            final zipcodeProvider =
                Provider.of<ZipcodeListProvider>(context, listen: false);
            await showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return StatefulBuilder(
                  builder: (BuildContext buildContext, StateSetter setStater) {
                    zipcodeProvider.zipcodeState = setStater;
                    /*  context
                        .read<ZipcodeListProvider>()
                        .setZipcodeState(setStater);*/
                    return AlertDialog(
                      scrollable: true,
                      content: Consumer<ZipcodeListProvider>(
                          builder: (context, data, child) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                getTranslated(
                                    context, 'SELECT_SERVICEABLE_ZIPCODE_LBL')!,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: primary),
                              ),
                              const Divider(color: lightBlack),
                              Flexible(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: SingleChildScrollView(
                                      // physics: AlwaysScrollableScrollPhysics(),
                                      controller: controller,
                                      child: Column(
                                        children: [
                                          data.isLoading
                                              ? const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 50.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    data.zipcodeList.isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: () {
                                                              return data
                                                                  .zipcodeList
                                                                  .asMap()
                                                                  .map((index,
                                                                          element) =>
                                                                      MapEntry(
                                                                          index,
                                                                          CheckboxListTile(
                                                                            title:
                                                                                Text(element.zipcode!),
                                                                            value:
                                                                                selectedZipcodeList.contains(element.zipcode),
                                                                            //value: true,
                                                                            onChanged:
                                                                                (_) {
                                                                              if (selectedZipcodeList.contains(element.zipcode)) {
                                                                                setStater(() {
                                                                                  selectedZipcodeList.remove(element.zipcode);
                                                                                  if (selectedZipcodeList.isNotEmpty) {
                                                                                    isZipcodeSelected = true;
                                                                                  } else {
                                                                                    isZipcodeSelected = false;
                                                                                  }
                                                                                });
                                                                              } else {
                                                                                setStater(() {
                                                                                  selectedZipcodeList.add(element.zipcode!);
                                                                                  if (selectedZipcodeList.isNotEmpty) {
                                                                                    isZipcodeSelected = true;
                                                                                  } else {
                                                                                    isZipcodeSelected = false;
                                                                                  }
                                                                                });
                                                                              }
                                                                              setState(() {});
                                                                            },
                                                                          )))
                                                                  .values
                                                                  .toList();
                                                            }(),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        20.0),
                                                            child: Text(
                                                                getTranslated(
                                                                    context,
                                                                    'ZIPCODE_IS_NOT_AVAIL_LBL')!),
                                                          ),
                                                    DesignConfiguration
                                                        .showCircularProgress(
                                                      data.isLoadingmore!,
                                                      primary,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      )),
                                ),
                              )
                            ]);
                      }),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      Future.delayed(Duration.zero).then(
        (value) => context
            .read<SignupAuthenticationProvider>()
            .getSignupData(
                address: addressController.text.trim(),
                confirmPass: confirmPasswordController.text.trim(),
                email: emailController.text.trim(),
                context: context,
                licenses: licenseImages,
                mobile: mobileController.text.trim(),
                name: nameController.text.trim(),
                password: passwordController.text.trim(),
                zipcodes: commaSeperatedSelectedZipcodesList!)
            .then(
          (
            value,
          ) async {
            print("value****$value");
            bool error = value["error"];
            String? msg = value["message"];

            await buttonController!.reverse();
            if (!error) {
              setSnackbar(msg!, context);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => Login(),
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
}
