import 'package:flutter/material.dart';
import 'package:sound/features/chat/view_model/all_message_view_model.dart';

class AllMessageInheritedNotifier
    extends InheritedNotifier<AllMessageViewModel> {
  const AllMessageInheritedNotifier(
      {super.key,
      required AllMessageViewModel super.notifier,
      required super.child});

  static AllMessageViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AllMessageInheritedNotifier>()!
        .notifier!;
  }
}
