import 'package:flutter/material.dart';

class GlobalChatSettingsViewModel with ChangeNotifier {
  bool _isAudioModeOnly = false;
  bool _isShowCorrectionAlwaysOn = true;
  bool _isEachWordTranslationActive = false;
  bool _isAutoRecordingStart = false;
  bool _isChatCompleted = false;
  double _autoSubmitTime = 0;

  bool get isAudioModeOnly => _isAudioModeOnly;
  bool get isShowCorrectionAlwaysOn => _isShowCorrectionAlwaysOn;
  bool get isEachWordTranslationActive => _isEachWordTranslationActive;
  bool get isAutoRecordingStart => _isAutoRecordingStart;
  bool get isChatCompleted => _isChatCompleted;
  double get autoSubmitTime => _autoSubmitTime;

  set setIsAudioModeOnly(bool value) {
    _isAudioModeOnly = value;
    notifyListeners();
  }

  set setIsChatCompleted(bool value) {
    _isChatCompleted = value;

    notifyListeners();
  }

  set setIsShowCorrectionAlwaysOn(bool value) {
    _isShowCorrectionAlwaysOn = value;
    notifyListeners();
  }

  set setIsEachWordTranslationActive(bool value) {
    _isEachWordTranslationActive = value;
    notifyListeners();
  }

  set setIsAutoRecordingStart(bool value) {
    _isAutoRecordingStart = value;
    notifyListeners();
  }

  set setAutoSubmitTime(double value) {
    _autoSubmitTime = value;
    notifyListeners();
  }
}
