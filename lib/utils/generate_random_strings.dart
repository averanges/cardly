import 'dart:convert';
import 'dart:math';

String generateRandomString(int len) {
  Random random = Random.secure();
  List<int> tempInt = List.generate(len, (_) => random.nextInt(100));
  return base64UrlEncode(tempInt);
}
