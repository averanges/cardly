class TaskSingleModel {
  final int taskIndex;
  final Map<String, String> singleTask;
  bool taskCompleted;

  TaskSingleModel(
      {required this.singleTask,
      required this.taskIndex,
      this.taskCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      "index": taskIndex,
      "visibleTask": singleTask['visibleTask'],
      "hiddenTask": singleTask['hiddenTask'],
      "completed": taskCompleted
    };
  }

  void switchCompletion(bool completionState) {
    taskCompleted = completionState;
  }
}
