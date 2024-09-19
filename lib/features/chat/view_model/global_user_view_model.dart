import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound/models/language_model.dart';
import 'package:sound/utils/supported_languages.dart';

class GlobalUserViewModel extends ChangeNotifier {
  final List<LanguageModel> _languageModelsList = [];

  LanguageModel? _targetLanguage;
  LanguageModel? _translationLanguage;

  String? _targetLanguageName;
  String? _translationLanguageName;

  User? _user;
  late SharedPreferences _preferences;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _usersCollection;

  GlobalUserViewModel() {
    _initState();
  }
  void _initState() async {
    await _initSharedPreferences();
    initializeLanguages();
  }

  Future<void> _initSharedPreferences() async {
    _user = FirebaseAuth.instance.currentUser;
    _preferences = await SharedPreferences.getInstance();
    _usersCollection = _firestore.collection('user');

    _targetLanguageName = _preferences.getString('targetLanguageName');
    _translationLanguageName =
        _preferences.getString('translationLanguageName');
  }

  void initializeLanguages() {
    for (var language in supportedLanguages) {
      _languageModelsList.add(LanguageModel(
          name: language['name']!,
          countryCode: language['code2']!,
          languageCode: language['code1']!));
    }

    if (_targetLanguageName != null && _translationLanguageName != null) {
      for (var language in _languageModelsList) {
        if (language.name == _targetLanguageName) {
          _targetLanguage = language;
        } else if (language.name == _translationLanguageName) {
          _translationLanguage = language;
        }
      }
    } else {
      if (_user != null) {
        DocumentReference userDoc = _usersCollection.doc(_user!.uid);
        userDoc.get().then((DocumentSnapshot document) {
          if (document.exists) {
            Map<String, dynamic> userData =
                document.data() as Map<String, dynamic>;
            for (var language in _languageModelsList) {
              if (language.name == userData['targetLang']) {
                _targetLanguage = language;
                _preferences.setString('targetLanguageName', language.name);
              } else if (language.name == userData['translationLang']) {
                _translationLanguage = language;
                _preferences.setString(
                    'translationLanguageName', language.name);
              }
            }
          }
        });
      }
    }
    notifyListeners();
  }

  LanguageModel get targetLanguage => _targetLanguage ?? LanguageModel();
  LanguageModel get translationLanguage =>
      _translationLanguage ?? LanguageModel();
  List<LanguageModel> get languageModelsList => _languageModelsList;

  void clearLanguagesState() {
    _targetLanguage = null;
    _translationLanguage = null;
  }

  set targetLanguage(LanguageModel language) {
    _targetLanguage = language;

    _preferences.setString('targetLanguageName', language.name);
    notifyListeners();
  }

  set translationLanguage(LanguageModel language) {
    _translationLanguage = language;
    _preferences.setString('translationLanguageName', language.name);
    notifyListeners();
  }
}
