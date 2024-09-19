import 'package:groq_sdk/groq_sdk.dart';
import 'package:sound/features/chat/model/groq_base_config.dart';
import 'package:sound/utils/transform_list.dart';

extension ChatRoleExtenstion on GrogBaseConfigChoice {
  String _groqForUserCompletedTaskString(String tasksString,
      ScenarioTypes scenarioType, ChatDifficultLevels level) {
    if (scenarioType == ScenarioTypes.question &&
        level == ChatDifficultLevels.advanced) {
      return '''
You are an AI assistant focused on evaluation user's message. Score the user based on these criteria:

1) Tone (formal or informal): +10 for formal, -5 for too casual.
2) Words used (professional or colloquial): +10 for professional, -5 for overly informal.
3) Interaction quality (respect or rudeness): +15 for respectful, -15 for rude.
4) Quality of answers (clarity, relevance, detail): +20 for clear and relevant, -20 for vague or irrelevant.

Sum the score. Return only overall number. Do not include in response letters, only number. Always keep your response concise and directly relevant to the context.
''';
    } else if (scenarioType == ScenarioTypes.question &&
        level != ChatDifficultLevels.advanced) {
      return "You are an AI assistant focused on analyzing the user's request message. "
          "If the user's request matches or closely relates to one of the following tasks: $tasksString, "
          "then return the number corresponding to the task. Example [0]. If no task matches or is related, return [-1]. Always keep your response concise and directly relevant to the context.";
    } else {
      return "You are an AI assistant tasked with analyzing the user's message. Your goal is to check if the message contains any mention of a correct guess or answer."
          "If the message contains keywords or phrases like 'correct', 'right', 'I got it', 'nailed it', 'that's it', or any other pattern that fits a correct guess or answer (using pattern-matching techniques), return [correct]."
          "If no such keywords or phrases are detected, return an empty string. Always keep your response concise and directly relevant to the context.";
    }
  }

  String chatRole(String? tasksString, String aiRole,
      ScenarioTypes scenarioType, ChatDifficultLevels level) {
    switch (this) {
      case GrogBaseConfigChoice.groqForUserRequestResponse:
        if (aiRole.isNotEmpty) {
          return "$aiRole. Response no more than in 3 sentences.";
        } else {
          return "No ai role provided for this chat.";
        }
      case GrogBaseConfigChoice.groqForUserMistakesCorrect:
        return """You are an AI assistant focused on correcting grammar and lexical mistakes in the user's request. Provide both the corrected sentence and a short explanation of the corrections. If there are no mistakes, return [0] without additional text. Do not include any other responses, explanations, or additional text beyond the correction and its brief explanation. Here are some examples:
  - Input: 'What's the capital Great Britain has'
    Output: 'What's the capital of Great Britain?'
    Explanation: 'Added "of" to complete the phrase.'
  - Input: 'how about you tell me horror story dark one maybe'
    Output: 'How about you tell me a dark horror story?'
    Explanation: 'Reordered words for better sentence structure and added "a" for article.'
  - Input: 'This is a correct sentence.'
    Output: [0]""";
      case GrogBaseConfigChoice.groqForUserRequestHints:
        return """You are an AI assistant providing brief, single-sentence suggestions to help users continue their conversation. 
  - If the input message is '[default]', return a single example prompt that a user can start with. Only provide one example and keep it short. 
    Examples:
    - 'What's the capital of France?'
    - 'Tell me a fun fact about space.'
    - 'Can you suggest a good book to read?'
  - If the input is part of a conversation, analyze the context and return one short suggestion on how the user can continue the conversation. 
    Examples:
    - For a question, suggest a follow-up question or a related topic in one sentence.
    - For an informative statement, propose a related question or topic for further exploration in one sentence.
  Always keep your response concise and directly relevant to the context.""";
      case GrogBaseConfigChoice.groqForUserCompletedTasks:
        if (tasksString != null && tasksString.isNotEmpty) {
          return _groqForUserCompletedTaskString(
              tasksString, scenarioType, level);
        } else {
          return "No tasks provided for completion analysis.";
        }
      default:
        return "Unknown role.";
    }
  }
}

class GroqChatRoleSettingModel {
  final Groq groq;
  final GrogBaseConfigChoice groqConfigChoice;
  String? tasksString;
  final String aiRole;
  final ScenarioTypes scenarioType;
  final ChatDifficultLevels level;
  GroqChat? _chat;

  int? groqOutputChoices;

  GroqChatRoleSettingModel(
      {required this.groq,
      required this.groqConfigChoice,
      required this.level,
      required this.scenarioType,
      this.tasksString,
      required this.aiRole}) {
    groqOutputChoices =
        groqConfigChoice == GrogBaseConfigChoice.groqForUserRequestHints
            ? 3
            : 1;
    _chat =
        groq.startNewChat(GroqModels.llama3_70b, settings: GroqChatSettings());
    initChatRole(tasksString, aiRole, scenarioType);
  }

  Future<void> initChatRole(
      String? tasksString, String aiRole, ScenarioTypes scenarioType) async {
    try {
      await _chat!.sendMessage(
          groqConfigChoice.chatRole(tasksString, aiRole, scenarioType, level),
          role: GroqMessageRole.system);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> sendMessage(String userPromtMessage) async {
    try {
      final (response, _) = await _chat!
          .sendMessage(userPromtMessage, role: GroqMessageRole.user);
      return response.choices.first.message;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
