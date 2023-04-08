import 'dart:developer';

import 'package:chatgpt_flutter_app/constants/constants.dart';
import 'package:chatgpt_flutter_app/models/Chat.dart';
import 'package:chatgpt_flutter_app/providers/text_provider.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:chatgpt_flutter_app/services/assets_manager.dart';
import 'package:chatgpt_flutter_app/services/model_bottomsheet.dart';
import 'package:chatgpt_flutter_app/widgets/ChatWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../providers/text_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  double _scrollPosition = 1.0;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  void clearChat() {
    setState(() {
      chatList = [];
    });
  }

  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(
                      0,
                      7.0,
                    ),
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage(AssetManager.chatImage),
                          radius: 22,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "ChatGPT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            _isTyping
                                ? Text(
                                    "Thinking...",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue[300]),
                                  )
                                : Text(
                                    "online",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue[300]),
                                  )
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await modalBottemSheet.showModalSheet(
                            context: context, chatClear: clearChat);
                      },
                      child: Icon(
                        Icons.more_vert_outlined,
                        color: botTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  // controller: _listScrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                        msg: chatList[index].msg.toString(),
                        positionIndex: index,
                        chatIndex:
                            int.parse(chatList[index].chatIndex.toString()));
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                  color: myTextColor,
                  border: Border(
                      top: BorderSide(
                          color: botTextColor.withOpacity(0.2), width: 0.7))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(25)),
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          cursorWidth: 1,
                          focusNode: focusNode,
                          enabled: _isTyping ? false : true,
                          autofocus: true,
                          controller: textEditingController,
                          onSubmitted: ((value) async {
                            await sendMessagesFCT(
                                modelsProvider: modelsProvider,
                                prompt: value.toString());
                          }),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration.collapsed(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(
                                  color: botTextColor.withOpacity(0.5),
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.14,
                      width: MediaQuery.of(context).size.width * 0.14,
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: _isTyping
                            ? SpinKitFadingCircle(
                                size: 20,
                                color: botTextColor,
                              )
                            : IconButton(
                                iconSize: 22,
                                style: IconButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () async {
                                  await sendMessagesFCT(
                                      modelsProvider: modelsProvider,
                                      prompt: textEditingController.text
                                          .toString());
                                },
                                icon: Icon(
                                  Icons.send_rounded,
                                  color: botTextColor,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ],
      )),
    );
  }

  void scrollListToEnd() {
    if (_listScrollController.positions.isNotEmpty) {
      _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> sendMessagesFCT(
      {required ModelsProvider modelsProvider, required String prompt}) async {
    try {
      if (prompt.toString().isNotEmpty) {
        setState(() {
          _isTyping = true;
          chatList.add(ChatModel(msg: prompt, chatIndex: 0));
          textEditingController.clear();
          focusNode.unfocus();
        });
        chatList.addAll(await APIService.sendMessage(
          msg: prompt,
          modelId: modelsProvider.getCurrentModel,
        ));
        setState(() {});
      }
    } catch (e) {
      log("$e");
    } finally {
      setState(() {
        _isTyping = false;
      });
      scrollListToEnd();
    }
  }
}



  // _listScrollController.positions.isNotEmpty &&
  //                 _listScrollController.position.maxScrollExtent -
  //                         _listScrollController.position.pixels <
  //                     20
  //             ? Text("")
  //             : GestureDetector(
  //                 onTap: () {
  //                   // print(_listScrollController.position.maxScrollExtent -
  //                   //     _listScrollController.position.pixels);
  //                   scrollListToEnd();
  //                 },
  //                 child: Container(
  //                   alignment: Alignment.bottomRight,
  //                   margin: EdgeInsets.fromLTRB(0, 0, 15, 80),
  //                   child: Container(
  //                       height: 35,
  //                       width: 35,
  //                       decoration: BoxDecoration(
  //                           color: Color.fromRGBO(72, 165, 195, 1),
  //                           borderRadius: BorderRadius.circular(20)),
  //                       child: Center(
  //                           child: Icon(
  //                         Icons.arrow_drop_down_rounded,
  //                         size: 35,
  //                         color: myTextColor,
  //                       ))),
  //                 ),
  //               )