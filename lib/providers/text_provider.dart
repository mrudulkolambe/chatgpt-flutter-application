import 'package:flutter/cupertino.dart';

class TextProvider with ChangeNotifier {
  String currentTextValue = "";

  String get getCurrentTextValue {
    return currentTextValue;
  }

  void setCurrentModel(String newText) {
    currentTextValue = newText;
    notifyListeners();
  }

}
