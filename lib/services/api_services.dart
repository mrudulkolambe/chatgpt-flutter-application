import 'dart:convert';
import 'dart:io';

import 'package:chatgpt_flutter_app/constants/constants.dart';
import 'package:chatgpt_flutter_app/models/Chat.dart';
import 'package:chatgpt_flutter_app/models/Models.dart';
import 'package:http/http.dart' as http;

class APIService {
  static Future<List<Models>> getModels() async {
    try {
      var response = await http.get(Uri.parse('$baseURL/models'), headers: {
        'Authorization':
            "Bearer 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"
      });

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
      }
      return Models.modelFromSnapshot(temp);
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String msg, required String modelId}) async {
    List<ChatModel> chatList = [];
    try {
      var response = await http.post(
        Uri.parse('https://openai-backend.vercel.app/app-chatgpt'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer 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"
        },
        body: jsonEncode(
          {"model": modelId, "prompt": msg, "max_tokens": 2000},
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        chatList.add(
            ChatModel(msg: jsonResponse['error']['message'], chatIndex: 2));
        throw HttpException(jsonResponse['error']["message"]);
      }
      chatList = List.generate(
          1,
          (index) =>
              ChatModel(msg: jsonResponse["choices"][0]["text"], chatIndex: 1));
    } catch (error) {}
    return chatList;
  }
}
