import 'package:chatgpt_flutter_app/widgets/DropdownWidget.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class modalBottemSheet {
  static Future<void> showModalSheet(
      {required BuildContext context, required chatClear}) async {
    await showModalBottomSheet(
        constraints: BoxConstraints.tight(Size(double.infinity, 150)),
        backgroundColor: cardColor,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      chatClear();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: myTextColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Clear The Chat",
                              style: TextStyle(color: botTextColor),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 12,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Choosen Model: ",
                          style: TextStyle(color: botTextColor),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(flex: 2, child: DropDownWidget())
                    ]),
              ],
            ),
          );
        });
  }
}
