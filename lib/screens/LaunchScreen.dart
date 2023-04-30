import 'package:chatgpt_flutter_app/constants/constants.dart';
import 'package:chatgpt_flutter_app/screens/ChatScreen.dart';
import 'package:chatgpt_flutter_app/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {


  void initState() {
    super.initState();
    _navigateHome();
  }

  void _navigateHome() async {
    await Future.delayed(Duration(milliseconds: 2000), (() {}));
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>  ChatScreen(),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetManager.chatImage,
                  height: 60,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "ChatGPT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(
                  height: 15,
                ),
                SpinKitThreeBounce(
                  size: 16,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
