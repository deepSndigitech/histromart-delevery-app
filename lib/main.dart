import 'dart:io';
import 'package:deliveryboy_multivendor/Provider/AuthProvider.dart';
import 'package:deliveryboy_multivendor/Provider/SystemProvider.dart';
import 'package:deliveryboy_multivendor/Provider/UserProvider.dart';
import 'package:deliveryboy_multivendor/Provider/WalletProvider.dart';
import 'package:deliveryboy_multivendor/Provider/signupProvider.dart';
import 'package:deliveryboy_multivendor/Provider/zipcodeListProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/color.dart';
import 'Helper/constant.dart';
import 'Helper/push_notification_service.dart';
import 'Localization/Demo_Localization.dart';
import 'Localization/Language_Constant.dart';
import 'Provider/SettingsProvider.dart';
import 'Provider/cashCollectionProvider.dart';
import 'Provider/homeProvider.dart';
import 'Provider/notificationListProvider.dart';
import 'Provider/orderDetailProvider.dart';
import 'Screens/DeshBord/deshBord.dart';
import 'Screens/Splash/splash.dart';
import 'Widget/systemChromeSettings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    if (Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } else {
    await Firebase.initializeApp();
  }

  SystemChromeSettings.setSystemButtomNavigationonlyTop();
  SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MyApp(
      sharedPreferences: prefs,
    ),
  );
}

class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;

  MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted) {
      setState(
        () {
          _locale = locale;
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then(
      (locale) {
        if (mounted) {
          setState(
            () {
              _locale = locale;
            },
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingProvider>(
          create: (context) => SettingProvider(widget.sharedPreferences),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<SystemProvider>(
            create: (context) => SystemProvider()),
        ChangeNotifierProvider<CashCollectionProvider>(
            create: (context) => CashCollectionProvider()),
        ChangeNotifierProvider<OrderDetailProvider>(
            create: (context) => OrderDetailProvider()),
        ChangeNotifierProvider<NotificationListProvider>(
            create: (context) => NotificationListProvider()),
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider()),
        ChangeNotifierProvider<MyWalletProvider>(
            create: (context) => MyWalletProvider()),
        ChangeNotifierProvider<ZipcodeListProvider>(
            create: (context) => ZipcodeListProvider()),
        ChangeNotifierProvider<SignupAuthenticationProvider>(
            create: (context) => SignupAuthenticationProvider()),
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: primary_app,
          fontFamily: 'opensans',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: _locale,
        localizationsDelegates: const [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale("zh", "CN"),
          Locale("es", "ES"),
          Locale("hi", "IN"),
          Locale("ar", "DZ"),
          Locale("ru", "RU"),
          Locale("ja", "JP"),
          Locale("de", "DE")
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/home': (context) => Dashboard(),
        },
      ),
    );
  }
}
