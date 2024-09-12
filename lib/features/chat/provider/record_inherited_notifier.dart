import 'package:flutter/material.dart';
import 'package:sound/features/chat/view_model/record_view_model.dart';

class RecordInheritedNotifier extends InheritedNotifier<RecordViewModel> {
  const RecordInheritedNotifier({
    super.key,
    required RecordViewModel super.notifier,
    required super.child,
  });

  static RecordViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RecordInheritedNotifier>()!
        .notifier!;
  }
}
