import 'package:flutter/material.dart';
import 'package:sound/models/language_model.dart';
import 'package:sound/utils/supported_languages.dart';

class GlobalUserViewModel extends ChangeNotifier {
  final List<LanguageModel> _languageModelsList = [];

  late LanguageModel _targetLanguage;
  late LanguageModel _translationLanguage;

  GlobalUserViewModel() {
    _initializeLanguages();
  }

  void _initializeLanguages() {
    for (var language in supportedLanguages) {
      _languageModelsList.add(LanguageModel(
          name: language['name']!,
          countryCode: language['code2']!,
          languageCode: language['code1']!));
    }
    _targetLanguage = _languageModelsList[0];
    _translationLanguage = _languageModelsList[1];
  }

  LanguageModel get targetLanguage => _targetLanguage;
  LanguageModel get translationLanguage => _translationLanguage;
  List<LanguageModel> get languageModelsList => _languageModelsList;

  set targetLanguage(LanguageModel language) {
    _targetLanguage = language;
    notifyListeners();
  }

  set translationLanguage(LanguageModel language) {
    _translationLanguage = language;
    notifyListeners();
  }
}
