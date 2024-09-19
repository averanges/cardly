import 'dart:math';

String generateRandomNumberSequences() {
  Random random = Random.secure();
  String intString = List.generate(10, (_) => random.nextInt(10)).join('');
  return intString;
}
