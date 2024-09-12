import 'package:flutter/material.dart';
import 'package:sound/models/task_single_model.dart';

class TasksCompletedViewModel extends ChangeNotifier {
  TasksCompletedViewModel({required this.tasksList}) {
    for (var i = 0; i < tasksList.length; i++) {
      _tasksCompletionMapsList
          .add(TaskSingleModel(singleTask: tasksList[i], taskIndex: i).toMap());
    }
  }
  final List<Map<String, String>> tasksList;
  final List<Map<String, dynamic>> _tasksCompletionMapsList = [];
  final Map<int, bool> _animationCompletedMap = {};

  Map<int, bool> get animationCompletedMap => _animationCompletedMap;
  List<Map<String, dynamic>> get tasksCompletionMapsList =>
      _tasksCompletionMapsList;

  String tasksToString() {
    String result = _tasksCompletionMapsList.fold("", (previousValue, element) {
      final idx = element["index"];
      final task = element["hiddenTask"];
      print(task);
      return "$previousValue$idx) $task ";
    });

    return result;
  }

  int completedTasksNumber() {
    int count = 0;

    for (Map task in _tasksCompletionMapsList) {
      if (task['completed'] == true) {
        count++;
      }
    }
    return count;
  }
}
