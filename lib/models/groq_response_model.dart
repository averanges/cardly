import 'dart:convert';

class GroqResponseModel {
  final String responseMessage;
  final String mistakes;

  GroqResponseModel({
    required this.responseMessage,
    required this.mistakes,
  });

  factory GroqResponseModel.fromJson(Map<String, dynamic> json) {
    return GroqResponseModel(
        responseMessage: json['response'] as String,
        mistakes: json['mistakes'] as String);
  }

  static GroqResponseModel fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return GroqResponseModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {'response': responseMessage, 'mistakes': mistakes};
  }

  static String sanitizeJsonString(String jsonString) {
    jsonString = jsonString.replaceAll('  ', ' ');
    jsonString = jsonString.replaceAll('\n', '');
    jsonString = jsonString.replaceAll('\t', '');
    // Add other replacements as needed

    return jsonString;
  }
}
