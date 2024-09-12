import 'package:flutter/material.dart';
import 'package:sound/models/message_model.dart';

class AllMessageViewModel extends ChangeNotifier {
  final List<MessageModel> _allMessages = [];
  final List<String> _listOfHints = [];
  String previousLastMessage = '';

  List<MessageModel> get allMessages => _allMessages;
  List<String> get listOfHints => _listOfHints;

  void addMessage(MessageModel messageModel) {
    _allMessages.add(messageModel);
    notifyListeners();
  }

  void removeMessage(MessageModel messageModel) {
    _allMessages.remove(messageModel);
  }

  void addMessageToListOfHints(String message) {
    _listOfHints.add(message);
    notifyListeners();
  }

  String findLastOneByType(MessageTypes type) {
    MessageModel? lastMessageModelByType = _allMessages.lastWhere(
        (el) => el.type == type,
        orElse: () => MessageModel(messageContent: '', type: type));
    if (previousLastMessage != lastMessageModelByType.messageContent) {
      previousLastMessage = lastMessageModelByType.messageContent;
      _listOfHints.clear();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    if (lastMessageModelByType.messageContent.isEmpty) {
      return '[default]';
    }
    return lastMessageModelByType.messageContent;
  }
}
