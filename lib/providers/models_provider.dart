import 'package:chatgpt_flutter_app/models/Models.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "text-davinci-003";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<Models> modelsList = [];

  List<Models> get getModelsList {
    return modelsList;
  }

  Future<List<Models>> getAllModels() async {
    modelsList = await APIService.getModels();
    return modelsList;
  }
}