import 'package:chatgpt_flutter_app/constants/constants.dart';
import 'package:chatgpt_flutter_app/models/Models.dart';
import 'package:chatgpt_flutter_app/providers/models_provider.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String ?currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);

    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<Models>>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? SizedBox.shrink()
              : FittedBox(
                child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: snapshot.data!.map((model) {
                      return DropdownMenuItem<String>(
                          child: Text(
                            model.id,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          value: model.id);
                    }).toList(),
                    value: currentModel,
                    onChanged: (value) {
                      setState(() {
                        currentModel = value.toString();
                      });
                      modelsProvider.setCurrentModel(value.toString());
                    },
                  ),
              );
        });
  }
}