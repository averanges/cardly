import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq_sdk/groq_sdk.dart';
import 'package:sound/features/chat/model/groq_chat_role_setting_model.dart';
import 'package:sound/utils/transform_list.dart';

enum GrogBaseConfigChoice {
  groqForUserRequestResponse,
  groqForUserMistakesCorrect,
  groqForUserRequestHints,
  groqForUserCompletedTasks
}

extension GroqBaseConfigChoiceExtension on GrogBaseConfigChoice {
  String get api {
    switch (this) {
      case GrogBaseConfigChoice.groqForUserRequestResponse:
        return dotenv.env['GROQ_API_KEY1']!;
      case GrogBaseConfigChoice.groqForUserMistakesCorrect:
        return dotenv.env['GROQ_API_KEY2']!;
      case GrogBaseConfigChoice.groqForUserRequestHints:
        return dotenv.env['GROQ_API_KEY3']!;
      case GrogBaseConfigChoice.groqForUserCompletedTasks:
        return dotenv.env['GROQ_API_KEY4']!;
    }
  }
}

class GroqBaseConfig {
  final GrogBaseConfigChoice groqConfigChoice;
  String? tasksString;
  final String aiRole;
  final ScenarioTypes scenarioType;
  final ChatDifficultLevels level;
  Groq? _groq;

  GroqBaseConfig(
      {required this.groqConfigChoice,
      required this.scenarioType,
      required this.level,
      this.tasksString,
      required this.aiRole}) {
    _groq = Groq(groqConfigChoice.api);
  }

  GroqChatRoleSettingModel get groqChatRoleModel {
    _groq ??= Groq(groqConfigChoice.api);
    if (groqConfigChoice == GrogBaseConfigChoice.groqForUserCompletedTasks) {
      return GroqChatRoleSettingModel(
          level: level,
          scenarioType: scenarioType,
          groq: _groq!,
          groqConfigChoice: groqConfigChoice,
          aiRole: aiRole,
          tasksString: tasksString);
    } else {
      return GroqChatRoleSettingModel(
          level: level,
          aiRole: aiRole,
          groq: _groq!,
          groqConfigChoice: groqConfigChoice,
          scenarioType: scenarioType);
    }
  }
}
