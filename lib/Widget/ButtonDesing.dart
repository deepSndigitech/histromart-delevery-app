import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Helper/color.dart';
import '../Helper/constant.dart';

class SimBtn extends StatelessWidget {
  final String? title;
  final VoidCallback? onBtnSelected;
  double? size;

  SimBtn({Key? key, this.title, this.onBtnSelected, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width * size!;
    return _buildBtnAnimation(context);
  }

  Widget _buildBtnAnimation(BuildContext context) {
    return CupertinoButton(
      child: Container(
        width: size,
        height: 35,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [grad1Color, grad2Color],
            stops: [0, 1],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(circularBorderRadius10),
          ),
        ),
        child: Text(
          title!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: white,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
      onPressed: () {
        onBtnSelected!();
      },
    );
  }
}

class AppBtn extends StatelessWidget {
  final String? title;
  final AnimationController? btnCntrl;
  final Animation? btnAnim;
  final VoidCallback? onBtnSelected;

  const AppBtn({
    Key? key,
    this.title,
    this.btnCntrl,
    this.btnAnim,
    this.onBtnSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildBtnAnimation,
      animation: btnCntrl!,
    );
  }

  Widget _buildBtnAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: CupertinoButton(
        child: Container(
          width: btnAnim!.value,
          height: 45,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [grad1Color, grad2Color],
              stops: [0, 1],
            ),
            borderRadius: BorderRadius.all(
              const Radius.circular(circularBorderRadius10),
            ),
          ),
          child: btnAnim!.value > 75.0
              ? Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: white,
                        fontWeight: FontWeight.normal,
                      ),
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
        ),
        onPressed: () {
          onBtnSelected!();
        },
      ),
    );
  }
}
