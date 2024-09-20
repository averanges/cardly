// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `No need to worry. Tell us your e-mail and we will send you link to reset you password!`
  String get noNeedToWorryTellUsYourEmailAndWe {
    return Intl.message(
      'No need to worry. Tell us your e-mail and we will send you link to reset you password!',
      name: 'noNeedToWorryTellUsYourEmailAndWe',
      desc: '',
      args: [],
    );
  }

  /// `Email...`
  String get emailHintWIthDots {
    return Intl.message(
      'Email...',
      name: 'emailHintWIthDots',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login?`
  String get backToLogin {
    return Intl.message(
      'Back to Login?',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Password...`
  String get passwordHintWithDots {
    return Intl.message(
      'Password...',
      name: 'passwordHintWithDots',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password...`
  String get repeatPasswordHintWithDots {
    return Intl.message(
      'Repeat password...',
      name: 'repeatPasswordHintWithDots',
      desc: '',
      args: [],
    );
  }

  /// `User already logged in`
  String get userAlreadyLoggedIn {
    return Intl.message(
      'User already logged in',
      name: 'userAlreadyLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.`
  String get anUnexpectedErrorOccurred {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'anUnexpectedErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Guest Mode`
  String get guestMode {
    return Intl.message(
      'Guest Mode',
      name: 'guestMode',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account yet?`
  String get dontHaveAnAccountYet {
    return Intl.message(
      'Don`t have an account yet?',
      name: 'dontHaveAnAccountYet',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get mainSloganWord1 {
    return Intl.message(
      'Choose',
      name: 'mainSloganWord1',
      desc: '',
      args: [],
    );
  }

  /// `Your`
  String get mainSloganWord2 {
    return Intl.message(
      'Your',
      name: 'mainSloganWord2',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get mainSloganWord3 {
    return Intl.message(
      'Card',
      name: 'mainSloganWord3',
      desc: '',
      args: [],
    );
  }

  /// `Click on card to start your learning journey!`
  String get clickOnCardToStartYourLearningJourney {
    return Intl.message(
      'Click on card to start your learning journey!',
      name: 'clickOnCardToStartYourLearningJourney',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Manage your profile details.`
  String get manageYourProfileDetails {
    return Intl.message(
      'Manage your profile details.',
      name: 'manageYourProfileDetails',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account settings.`
  String get manageYourAccountSettings {
    return Intl.message(
      'Manage your account settings.',
      name: 'manageYourAccountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Log out from this profile.`
  String get logOutFromThisProfile {
    return Intl.message(
      'Log out from this profile.',
      name: 'logOutFromThisProfile',
      desc: '',
      args: [],
    );
  }

  /// `Target Language`
  String get targetLanguage {
    return Intl.message(
      'Target Language',
      name: 'targetLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
