import 'package:deliveryboy_multivendor/Screens/Home/Widget/getOrderIteam.dart';
import 'package:flutter/material.dart';
import '../../../Widget/parameterString.dart';

class DetailHeader extends StatelessWidget {
  Function update;
  DetailHeader({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      child: SizedBox(
        width: deviceWidth,
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CommanDesingWidget(
              index: 0,
              title: 'Orders',
              update: update,
            ),
            CommanDesingWidget(
              index: 1,
              title: 'Received',
              update: update,
            ),
            CommanDesingWidget(
              index: 2,
              title: 'Processed',
              update: update,
            ),
            CommanDesingWidget(
              index: 3,
              title: 'Shipped',
              update: update,
            ),
            CommanDesingWidget(
              index: 4,
              title: 'Delivered',
              update: update,
            ),
            CommanDesingWidget(
              index: 5,
              title: 'Cancelled ',
              update: update,
            ),
            CommanDesingWidget(
              index: 6,
              title: 'Returned',
              update: update,
            ),
          ],
        ),
      ),
    );
  }
}
