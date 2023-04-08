import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_flutter_app/constants/constants.dart';
import 'package:chatgpt_flutter_app/services/assets_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      required this.positionIndex});

  final String msg;
  final int chatIndex;
  final int positionIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onHorizontalDragStart: (details) {},
          child: Container(
            margin: widget.positionIndex == 0
                ? EdgeInsets.only(bottom: 10, top: 10)
                : EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    crossAxisAlignment: widget.chatIndex == 0
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.chatIndex == 0
                          ? Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: Color.fromRGBO(72, 165, 195, 1)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: SelectableText(
                                  "${widget.msg}",
                                  style: TextStyle(color: myTextColor),
                                ),
                              ),
                            )
                          : Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: myTextColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: SelectableText(
                                  widget.msg.trim(),
                                  style: TextStyle(color: botTextColor),
                                ),
                              ),
                            ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
