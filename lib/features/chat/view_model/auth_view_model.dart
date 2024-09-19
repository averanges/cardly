import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound/features/auth/user_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/models/language_model.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/new_user_profile_set_page.dart';
import 'package:sound/pages/starting_page.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/utils/generate_random_number_sequences.dart';
import 'package:sound/utils/generate_random_strings.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isGuestMode = false;
  User? _user;
  String? aT;
  String? guestName;
  late SharedPreferences preferences;
  UserModel? _userModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _usersCollection;
  final GlobalUserViewModel globalUserViewModel;

  AuthViewModel({required this.globalUserViewModel}) {
    _initialize();
  }

  Future<void> _initialize() async {
    preferences = await SharedPreferences.getInstance();
    _usersCollection = _firestore.collection('user');
    _user = FirebaseAuth.instance.currentUser;
    aT = preferences.getString('aT');
    guestName = preferences.getString('guestName');
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    try {
      if (_user != null || aT != null) {
        _isLoggedIn = true;
        if (aT != null &&
            aT!.isNotEmpty &&
            guestName != null &&
            guestName!.isNotEmpty) {
          _isGuestMode = true;
          _createUserModel(guestName!, aT!);
        } else {
          _isGuestMode = false;
          _createUserModel(_user!.email!, _user!.uid);
          _usersCollection
              .doc(_user!.uid)
              .get()
              .then((DocumentSnapshot document) {
            Map? data = (document.data() as Map?);
            if (data != null && data['name'] != null) {
              _updateUserModel(data['name']);
            }
          });
        }
      } else {
        _isLoggedIn = false;
        _isGuestMode = false;
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  UserModel? get userModel => _userModel;
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuestMode => _isGuestMode;

  Future<void> registration(
      {required String email,
      required String psw,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: psw)
          .then((credentials) => _user = credentials.user);
      await _usersCollection.doc(_user!.uid).set({'email': _user!.email});

      if (_user != null) {
        _checkLoginStatus();
        if (context.mounted) {
          Navigator.of(context)
              .push(customPageRouteBuild(const NewUserProfileSetPage()));
        }
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  void _createUserModel(email, id) {
    _userModel = UserModel(email: email, uid: id);
  }

  void _updateUserModel(value) {
    if (_userModel != null) _userModel!.userName = value;
  }

  Future<void> login(
      {required String email,
      required String psw,
      required BuildContext context}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: psw)
        .then((credentials) => _user = credentials.user);
    print(guestName);
    print(aT);
    print(_isGuestMode);
    if (_user != null) {
      globalUserViewModel.initializeLanguages();
      _checkLoginStatus();
      if (context.mounted) {
        Navigator.of(context).push(customPageRouteBuild(const EntryPoint()));
      }
    }
    notifyListeners();
  }

  Future<void> updateUserData({String? email, String? name}) async {
    try {
      if (_user != null) {
        if (email != null && email.isNotEmpty) {
          await _user!.verifyBeforeUpdateEmail(email);
        }
        if (name != null && name.isNotEmpty) {
          _usersCollection.doc(_user!.uid).update({'name': name});
        }
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> loginAsGuest(BuildContext context) async {
    String guestNumbers = generateRandomNumberSequences();
    await preferences.setString('aT', generateRandomString(10));
    await preferences.setString('guestName', "Guest $guestNumbers");

    String? aT = preferences.getString('aT');
    String? guestName = preferences.getString('guestName');

    if (aT != null && guestName != null) {
      _createUserModel(guestName, aT);
      _isGuestMode = true;
      if (context.mounted) {
        Navigator.of(context)
            .push(customPageRouteBuild(const NewUserProfileSetPage()));
      }
    } else {
      print('Failed to retrieve aT or guestName');
    }

    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  void _setLanguages(String targetLang, String translationLang) {
    for (LanguageModel language in globalUserViewModel.languageModelsList) {
      if (language.name == targetLang) {
        globalUserViewModel.targetLanguage = language;
      } else if (language.name == translationLang) {
        globalUserViewModel.translationLanguage = language;
      }
    }
  }

  Future<void> changePassword(String currentPsw, String newPsw) async {
    if (_user != null) {
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: _user!.email!, password: currentPsw);
      try {
        await _user!.reauthenticateWithCredential(authCredential);
        await _user!.updatePassword(newPsw);
      } on FirebaseAuthException catch (e) {
        rethrow;
      }
    }
    notifyListeners();
  }

  Future<void> authAddAdditionalInfo(context,
      {required String translationLang,
      required String targetLang,
      String? name}) async {
    Map<String, dynamic> object = {
      'translationLang': translationLang,
      'targetLang': targetLang,
    };

    if (name != null) {
      object['name'] = name;
    }
    try {
      if (!_isGuestMode) {
        await _usersCollection.doc(_user!.uid).update(object);
      }
      preferences.setString('targetLanguageName', object['targetLang']);
      preferences.setString(
          'translationLanguageName', object['translationLang']);

      _setLanguages(object['targetLang'], object['translationLang']);
      _updateUserModel(object['name']);
      notifyListeners();
      if (context.mounted) {
        Navigator.of(context).push(customPageRouteBuild(const EntryPoint()));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      if (_user == null) return;
      await _usersCollection.doc(_user!.uid).delete();
      await _user!.delete();
      if (context.mounted) {
        logout(context);
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (_isLoggedIn) {
        _isGuestMode = false;
        await FirebaseAuth.instance.signOut();

        _isLoggedIn = false;
        await preferences.remove('aT');
        await preferences.remove('guestName');
        await preferences.remove('targetLanguageName');
        await preferences.remove('translationLanguageName');

        guestName = '';
        aT = '';

        globalUserViewModel.clearLanguagesState();
      }
      if (_userModel != null) _userModel!.clearUserModel();
      notifyListeners();
      if (context.mounted) {
        Navigator.of(context)
            .pushReplacement(customPageRouteBuild(const StartScreen()));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }
}
