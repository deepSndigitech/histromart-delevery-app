import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../Profile/profile.dart';

class GetHeading extends StatelessWidget {
  Function update;
  GetHeading({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: DesignConfiguration.back(),
        padding: const EdgeInsets.only(
          left: 10.0,
          bottom: 10,
          top: 15,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CUR_USERNAME!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      getTranslated(context, WALLET_BAL)! +
                          ": ${DesignConfiguration.getPriceFormat(context, double.tryParse(CUR_BALANCE)??0.0)!}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: white, fontSize: 14),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 7,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getTranslated(context, EDIT_PROFILE_LBL)!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: white, fontSize: 14),
                          ),
                          const Icon(
                            Icons.arrow_right_outlined,
                            color: white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 10, right: 20),
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.0,
                    color: white,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(circularBorderRadius100),
                  child: Container(
                    height: 62,
                    width: 62,
                    child: Icon(
                      Icons.account_circle,
                      color: white,
                      size: 62,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Profile(),
          ),
        );
        update();
      },
    );
  }
}
