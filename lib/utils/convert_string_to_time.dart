String convertIntegerToTime(int time) {
  if (time == 0) {
    return "00:00";
  }
  int currentValue = time;
  int minutes = currentValue ~/ 60;
  int seconds = currentValue % 60;

  String minuteLeft = minutes.toString().padLeft(2, '0');
  String secondsLeft = seconds.toString().padLeft(2, '0');

  return "$minuteLeft:$secondsLeft";
}
