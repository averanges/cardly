import 'package:sound/models/message_model.dart';

class ScoreModel {
  List<MessageModel> allMessages;
  List<int> allResponseTimeData;
  int completedTasks;
  int allTasks;
  final int totalEvents;
  final List<int> completionIndexes;
  final int idealResponseTime;
  final int maxResponseTime;

  ScoreModel(
      {required this.allMessages,
      required this.allResponseTimeData,
      required this.totalEvents,
      required this.completionIndexes,
      required this.allTasks,
      required this.completedTasks,
      this.idealResponseTime = 5,
      this.maxResponseTime = 40});

  double getUserAccuracy() {
    int correctUserMessages =
        allMessages.where((element) => element.isCorrect == true).length;
    return (correctUserMessages / allMessages.length) * 100;
  }

  double _calculateTaskCompletionIndexScore() {
    double totalScore = 0;
    for (int index in completionIndexes) {
      totalScore += 100.0 * (totalEvents - index) / totalEvents;
    }
    return totalScore / completionIndexes.length;
  }

  double calculateTaskCompletionRatio() {
    return (completedTasks / allTasks) * 100;
  }

  double calculateEngagementScore({
    double w1 = 0.4,
    double w2 = 0.3,
    double w3 = 0.2,
  }) {
    return w1 * calculateOverallResponsivenessScore() +
        w2 * calculateTaskCompletionRatio() +
        w3 * _calculateTaskCompletionIndexScore();
  }

  double _calculateSingleScore(int responseTime) {
    if (responseTime <= idealResponseTime) {
      return 100.0;
    } else if (responseTime >= maxResponseTime) {
      return 0.0;
    } else {
      return 100.0 *
          (1 -
              (responseTime - idealResponseTime) /
                  (maxResponseTime - idealResponseTime));
    }
  }

  double calculateOverallResponsivenessScore() {
    if (allResponseTimeData.isEmpty) {
      return 0.0;
    }

    double totalScore = allResponseTimeData.fold(
        0.0, (sum, responseTime) => sum + _calculateSingleScore(responseTime));

    return totalScore / allResponseTimeData.length;
  }
}
