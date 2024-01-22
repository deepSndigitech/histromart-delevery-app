import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Provider/WalletProvider.dart';
import 'package:deliveryboy_multivendor/Screens/WalletHistory/Widget/GetDialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'Widget/ListItem.dart';

class WalletHistory extends StatefulWidget {
  final bool isBack;

  const WalletHistory({Key? key, required this.isBack}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return StateWallet();
  }
}

class StateWallet extends State<WalletHistory> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController controller = ScrollController();
  TextEditingController? amtC, bankDetailC, acc_num, ifsc_code, acc_name;

  @override
  void initState() {
    super.initState();
    context.read<MyWalletProvider>().getUserWalletTransactions(
        context: context, walletTransactionIsLoadingMore: true);

    controller.addListener(_scrollListener);
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
    amtC = TextEditingController();
    bankDetailC = TextEditingController();
  }

  getAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [grad1Color, grad2Color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Opacity(
              opacity: 0.17000000178813934,
              child: Container(
                  width: deviceWidth! * 0.9,
                  height: 1,
                  decoration: const BoxDecoration(color: white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.isBack
                      ? InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsetsDirectional.only(start: 15.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: white,
                              size: 25,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 15,
                        ),
                ),
                Container(
                  height: 36,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 9.0,
                      /*  start: 15,
                      end: 15, */
                    ),
                    child: Text(
                      getTranslated(context, WALLET)!,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: white,
                        fontSize: textFontSize16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 15.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            return GetDialogs.filterDialog(context);
                          },
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getBalanceShower() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: primary,
                  ),
                  Text(
                    " " + CURBAL_LBL,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Text(
                  DesignConfiguration.getPriceFormat(
                      context, double.parse(CUR_BALANCE))!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: black, fontWeight: FontWeight.bold)),
              SimBtn(
                size: 0.8,
                title: getTranslated(context, WITHDRAW_MONEY)!,
                onBtnSelected: () {
                  GetDialogs.withDrawMonetDiolog(context, amtC, acc_num,
                      ifsc_code, acc_name, bankDetailC, _formkey);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightWhite,
        key: _scaffoldKey,
        // appBar: GetAppBar.getAppBar(
        //   getTranslated(context, WALLET)!,
        //   context,
        // ),
        body: isNetworkAvail
            ? Consumer<MyWalletProvider>(
                builder: (context, value, child) {
                  if (value.getCurrentStatus == MyWalletStatus.isFailure) {
                    return Column(
                      children: [
                        getAppBar(),
                        Center(
                          child: Text(
                            value.errorMessage,
                          ),
                        ),
                      ],
                    );
                  } else if (value.getCurrentStatus ==
                      MyWalletStatus.isSuccsess) {
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: SingleChildScrollView(
                        controller: controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            getAppBar(),
                            getBalanceShower(),
                            value.walletTransactionList.isEmpty
                                ? Container(
                                    height: deviceHeight * 0.5,
                                    child: Center(
                                      child: Text(
                                        getTranslated(context, noItem)!,
                                      ),
                                    ),
                                  )
                                : MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: (value.transactionListOffset <
                                              value.transactionListTotal)
                                          ? value.walletTransactionList.length +
                                              1
                                          : value.walletTransactionList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return (index ==
                                                    value.walletTransactionList
                                                        .length &&
                                                value
                                                    .walletTransactionHasMoreData)
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : ListItem(
                                                index: index,
                                                model:
                                                    value.walletTransactionList[
                                                        index],
                                              );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const ShimmerEffect();
                },
              )
            : noInternet(
                context,
                setStateNoInternate,
                buttonSqueezeanimation,
                buttonController,
              ));
  }

  Future<void> _playAnimation() async {
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
          // getTransaction();
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
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    context.read<MyWalletProvider>().walletTransactionList.clear();
    context.read<MyWalletProvider>().transactionListOffset = 0;
    context.read<MyWalletProvider>().transactionListTotal = 0;
    context.read<MyWalletProvider>().isLoading = true;
    return context.read<MyWalletProvider>().getUserWalletTransactions(
        context: context, walletTransactionIsLoadingMore: true);
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(
          () {
            if (context.read<MyWalletProvider>().transactionListOffset <
                context.read<MyWalletProvider>().transactionListTotal)
              context.read<MyWalletProvider>().getUserWalletTransactions(
                  context: context, walletTransactionIsLoadingMore: true);
          },
        );
      }
    }
  }
}
