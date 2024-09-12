import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sound/features/chat/view_model/controller_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum LanguageChoice { ru, kr, en }

// extension LanguageChoiceStrings on LanguageChoice {
//   String get lang {
//     switch (this) {
//       case LanguageChoice.ru:
//         return 'ru_RU';
//       case LanguageChoice.en:
//         return 'en_EN';
//       case LanguageChoice.kr:
//         return 'ko_KR';
//     }
//   }
// }

class RecordViewModel extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  final List<String> _completeSpeech = [];
  String _temp = '';
  bool _isRecording = false;
  final ControllerViewModel controllerViewModel;

  final GlobalUserViewModel globalUserViewModel;

  void update() => notifyListeners();

  RecordViewModel(
      {required this.controllerViewModel, required this.globalUserViewModel}) {
    controllerViewModel.addListener(update);
  }
  @override
  void dispose() {
    controllerViewModel.removeListener(update);
    super.dispose();
  }

  bool get isRecording => _isRecording;

  TextEditingController get textController =>
      controllerViewModel.textController;
  List<String> get completeSpeech => _completeSpeech;

  Future<void> startUserListening() async {
    final options = SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    try {
      await _speech.listen(
          onResult: onResultListener,
          localeId: globalUserViewModel.targetLanguage.languageCode,
          listenOptions: options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateTextController(List<String> value) {
    controllerViewModel.setTextController = value.join(' ');
    notifyListeners();
  }

  void onResultListener(SpeechRecognitionResult res) {
    _completeSpeech.removeWhere((element) => element == ' ');
    final String recognizedText = res.recognizedWords;
    controllerViewModel.textController.selection = TextSelection.fromPosition(
        TextPosition(offset: controllerViewModel.textController.text.length));
    if (!res.finalResult) {
      if (_temp.isEmpty) {
        _completeSpeech.add(recognizedText);
      } else {
        _completeSpeech[_completeSpeech.length - 1] = recognizedText;
      }
      _temp = recognizedText;
    } else {
      _completeSpeech.removeLast();
      _completeSpeech.add(recognizedText);
      _isRecording = false;
      _temp = '';
    }
    controllerViewModel.setTextController = _completeSpeech.join(' ');
    notifyListeners();
    // print(_completeSpeech.join(' '));
  }

  Future<void> stopUserListening() async {
    try {
      await _speech.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onRecordTap() {
    _isRecording = !_isRecording;
    notifyListeners();
    if (_isRecording) {
      startUserListening();
    } else {
      stopUserListening();
    }
  }
}
