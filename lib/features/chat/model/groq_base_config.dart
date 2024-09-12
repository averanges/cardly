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
        return "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";
      case GrogBaseConfigChoice.groqForUserMistakesCorrect:
        return "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";
      case GrogBaseConfigChoice.groqForUserRequestHints:
        return "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";
      case GrogBaseConfigChoice.groqForUserCompletedTasks:
        return "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";
    }
  }
}

class GroqBaseConfig {
  final GrogBaseConfigChoice groqConfigChoice;
  String? tasksString;
  final String aiRole;
  final ScenarioTypes scenarioType;
  Groq? _groq;

  GroqBaseConfig(
      {required this.groqConfigChoice,
      required this.scenarioType,
      this.tasksString,
      required this.aiRole}) {
    _groq = Groq(groqConfigChoice.api);
  }

  GroqChatRoleSettingModel get groqChatRoleModel {
    _groq ??= Groq(groqConfigChoice.api);
    if (groqConfigChoice == GrogBaseConfigChoice.groqForUserCompletedTasks) {
      return GroqChatRoleSettingModel(
          scenarioType: scenarioType,
          groq: _groq!,
          groqConfigChoice: groqConfigChoice,
          aiRole: aiRole,
          tasksString: tasksString);
    } else {
      return GroqChatRoleSettingModel(
          aiRole: aiRole,
          groq: _groq!,
          groqConfigChoice: groqConfigChoice,
          scenarioType: scenarioType);
    }
  }
}
