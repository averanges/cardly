import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/firebase_options.dart';
import 'package:sound/generated/l10n.dart';
import 'package:sound/models/language_model.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/starting_page.dart';
import 'package:sound/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GlobalUserViewModel globalUserViewModel = GlobalUserViewModel();
  final AuthViewModel authViewModel =
      AuthViewModel(globalUserViewModel: globalUserViewModel);
  runApp(MainApp(
    authViewModel: authViewModel,
    globalUserViewModel: globalUserViewModel,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp(
      {super.key,
      required this.authViewModel,
      required this.globalUserViewModel});
  final AuthViewModel authViewModel;
  final GlobalUserViewModel globalUserViewModel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => globalUserViewModel),
        ChangeNotifierProvider(create: (context) => authViewModel)
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            textTheme:
                const TextTheme(bodyMedium: TextStyle(fontFamily: 'Jost'))),
        debugShowCheckedModeBanner: false,
        // locale: globalUserViewModel.translationLanguage.locale,
        localeListResolutionCallback: (locales, supportedLocales) {
          if (locales != null && locales.isNotEmpty) {
            for (LanguageModel language
                in globalUserViewModel.languageModelsList) {
              if (language.locale.languageCode == locales[0].languageCode) {
                globalUserViewModel.translationLanguage = language;
                return language.locale;
              }
            }
          }
          return globalUserViewModel.translationLanguage.locale;
        },
        home:
            authViewModel.isLoggedIn ? const EntryPoint() : const StartScreen(),
      ),
    );
  }
}
