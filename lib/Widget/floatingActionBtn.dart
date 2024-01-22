import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Helper/color.dart';
import '../Screens/DeshBord/deshBord.dart';

floatingBtn(BuildContext context) {
  return Container(
    height: 40.0,
    width: 40.0,
    child: FittedBox(
      child: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(
          Icons.add,
          size: 32,
          color: white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        },
      ),
      // const SizedBox(height: 10),
    ),
  );
}
