import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import '../../Helper/color.dart';
import '../../Helper/constant.dart';
import '../../Widget/desing.dart';
import '../CashCollection/cash_collection.dart';
import '../Home/home.dart';
import '../WalletHistory/wallet_history.dart';
import '../getDrawer/drawerWidget.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Widget> fragments;
  int _curBottom = 0;
  @override
  void initState() {
    super.initState();
    fragments = [
      Home(),
      WalletHistory(isBack: false),
      CashCollection(
        isBack: false,
      ),
      GetDrawerWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNav(),
      body: fragments[_curBottom],
    );
  }

  getBottomNav() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius13)),
          boxShadow: [
            BoxShadow(
                color: black12,
                offset: Offset(0, -3),
                blurRadius: 6,
                spreadRadius: 0)
          ],
          color: white),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(circularBorderRadius12),
          topLeft: Radius.circular(circularBorderRadius12),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: primary,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('home'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('homeSelected'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('wallet'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('walletSelected'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('cashCollection'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('cashCollectionSelected'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: 'Cash Collection',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('profile'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath('profileSelected'),
                height: 25,
                width: 25,
                colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
              ),
              label: 'Profile',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _curBottom,
          selectedItemColor: primary,
          onTap: (int index) {
            if (mounted) {
              setState(
                () {
                  _curBottom = index;
                },
              );
            }
          },
          elevation: 25,
        ),
      ),
    );
  }
}
