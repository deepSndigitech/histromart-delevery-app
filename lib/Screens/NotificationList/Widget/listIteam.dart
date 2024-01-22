import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/notification_model.dart';
import '../notification_lIst.dart';

class ListIteam extends StatelessWidget {
  int index;
  ListIteam({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Notification_Model model = notificationListProvider!.notiList[index];
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.date!,
                    style: TextStyle(
                      color: primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      model.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(model.desc!)
                ],
              ),
            ),
            model.img != ''
                ? Container(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(circularBorderRadius3),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(model.img!),
                        radius: 25,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
