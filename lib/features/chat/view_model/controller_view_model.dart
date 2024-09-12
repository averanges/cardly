import 'package:flutter/material.dart';

class ControllerViewModel extends ChangeNotifier {
  final TextEditingController _textController = TextEditingController();
  bool _isTextFieldReadOnly = true;

  TextEditingController get textController => _textController;
  bool get isTextFieldReadOnly => _isTextFieldReadOnly;

  set setTextController(String value) {
    _textController.text = value;
    notifyListeners();
  }

  void scrollToBottomOfListView(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
    notifyListeners();
  }

  void scrollToBottomAlways(ScrollController controller) {
    if (controller.hasClients) {
      _isTextFieldReadOnly = false;
      notifyListeners();
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.linear);
      Future.delayed(Duration.zero);
      _isTextFieldReadOnly = true;
      notifyListeners();
    }
  }
}
