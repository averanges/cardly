import 'package:translator/translator.dart';

class TranslateService {
  final GoogleTranslator translator;
  final String to;

  const TranslateService({required this.to, required this.translator});

  Future<String> translate(String originalMessage) async {
    final Translation translation =
        await translator.translate(originalMessage, to: to);
    return translation.text;
  }
}
