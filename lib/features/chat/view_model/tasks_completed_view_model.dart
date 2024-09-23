import 'package:flutter/material.dart';
import 'package:sound/models/task_single_model.dart';

class TasksCompletedViewModel extends ChangeNotifier {
  TasksCompletedViewModel({required this.tasksList}) {
    for (var i = 0; i < tasksList.length; i++) {
      _tasksCompletionMapsList
          .add(TaskSingleModel(singleTask: tasksList[i], taskIndex: i).toMap());
    }
  }
  double _progress = 0.0;
  bool _isChatCompletedSuccess = false;

  final List<Map<String, dynamic>> tasksList;
  final List<Map<String, dynamic>> _tasksCompletionMapsList = [];
  final Map<int, bool> _animationCompletedMap = {};

  double get progress => _progress;
  bool get isChatCompletedSuccess => _isChatCompletedSuccess;

  Map<int, bool> get animationCompletedMap => _animationCompletedMap;
  List<Map<String, dynamic>> get tasksCompletionMapsList =>
      _tasksCompletionMapsList;

  set isChatCompletedSuccess(bool value) {
    _isChatCompletedSuccess = value;
    notifyListeners();
  }

  String tasksToString() {
    String result = _tasksCompletionMapsList.fold("", (previousValue, element) {
      final idx = element["index"];
      final task = element["hiddenTask"];
      return "$previousValue$idx) $task ";
    });

    return result;
  }

  void toggleProgress() {
    final double progressStep = 1 / _tasksCompletionMapsList.length + 0.01;
    _progress += progressStep;
    if (progress > 1) {
      _isChatCompletedSuccess = true;
    }
    notifyListeners();
  }

  void addProgressForPictureDescription(int points) {
    _progress += points / 100;
    if (_progress > 1) {
      _isChatCompletedSuccess = true;
    }
    notifyListeners();
  }

  void addProgressForLikeScore(int points) {
    _progress += points / 100;
    if (_progress > 1) {
      _isChatCompletedSuccess = true;
    } else {}
    notifyListeners();
  }

  void completeManuallyTask(int index) {
    _tasksCompletionMapsList[index]['completed'] = true;
    notifyListeners();
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
