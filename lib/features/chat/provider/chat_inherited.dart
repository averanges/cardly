import 'package:flutter/material.dart';
import 'package:sound/features/chat/view_model/all_message_view_model.dart';
import 'package:sound/features/chat/view_model/groq_handle_view_model.dart';

class ChatInherited extends InheritedWidget {
  final AllMessageViewModel allMessageViewModel;
  final GroqHandleViewModel? groqHandleViewModel;

  const ChatInherited({
    super.key,
    required super.child,
    required this.allMessageViewModel,
    this.groqHandleViewModel,
  });

  static ChatInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatInherited>();
  }

  @override
  bool updateShouldNotify(ChatInherited oldWidget) {
    return oldWidget.allMessageViewModel != allMessageViewModel ||
        oldWidget.groqHandleViewModel != groqHandleViewModel;
  }
}
