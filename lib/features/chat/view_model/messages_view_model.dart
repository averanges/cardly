import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sound/features/chat/services/translate_service.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:translator/translator.dart';

class SingleMessageViewModel extends ChangeNotifier {
  String _translatedMessageContent = '';
  bool _isTextTranslated = false;
  bool _isLoading = false;

  final GlobalUserViewModel globalUserViewModel;

  late String _translateTo;

  SingleMessageViewModel({required this.globalUserViewModel}) {
    _translateTo =
        globalUserViewModel.translationLanguage.countryCode.toLowerCase();
  }

  final GoogleTranslator translator = GoogleTranslator();

  bool get isTextTranslated => _isTextTranslated;
  bool get isLoading => _isLoading;
  String get translatedMessageContent => _translatedMessageContent;

  TranslateService? _translateService;

  TranslateService get translateService {
    _translateService ??=
        TranslateService(to: _translateTo, translator: translator);
    return _translateService!;
  }

  Future<void> translate(String originalMessage) async {
    if (_translatedMessageContent.trim().isEmpty && !_isTextTranslated) {
      _isLoading = true;
      notifyListeners();
      _translatedMessageContent =
          await translateService.translate(originalMessage);
      _isLoading = false;
    }
    _isTextTranslated = !_isTextTranslated;
    notifyListeners();
  }
}
