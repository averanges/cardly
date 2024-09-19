import 'package:flutter/material.dart';
import 'package:sound/features/chat/model/groq_base_config.dart';
import 'package:sound/features/chat/model/groq_chat_role_setting_model.dart';
import 'package:sound/utils/transform_list.dart';

class GroqHandleViewModel extends ChangeNotifier {
  Map<GrogBaseConfigChoice, GroqChatRoleSettingModel> mapOfInitGroqChats = {};

  void initializeGroqChats(
      {String? tasksString,
      required String aiRole,
      required ChatDifficultLevels level,
      required ScenarioTypes scenarioType}) {
    for (var groqChoice in GrogBaseConfigChoice.values) {
      final groqConfig =
          groqChoice == GrogBaseConfigChoice.groqForUserCompletedTasks
              ? GroqBaseConfig(
                  scenarioType: scenarioType,
                  level: level,
                  aiRole: aiRole,
                  groqConfigChoice: groqChoice,
                  tasksString: tasksString)
              : GroqBaseConfig(
                  level: level,
                  groqConfigChoice: groqChoice,
                  aiRole: aiRole,
                  scenarioType: scenarioType);
      mapOfInitGroqChats[groqChoice] = groqConfig.groqChatRoleModel;
    }
  }

  Future<String> sendMessage(
      String message, GrogBaseConfigChoice choice) async {
    try {
      if (mapOfInitGroqChats.containsKey(choice)) {
        final response = await mapOfInitGroqChats[choice]!.sendMessage(message);
        notifyListeners();
        return response;
      } else {
        throw 'No chat model found for $choice';
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
