import 'package:flutter/material.dart';

class LanguageModel {
  LanguageModel({
    this.name = '',
    this.countryCode = '',
    this.languageCode = '',
    this.locale = const Locale('ko'),
  });

  final String name;
  final String countryCode;
  final String languageCode;
  final Locale locale;
}
