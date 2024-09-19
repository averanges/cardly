import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/firebase_options.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/starting_page.dart';
import 'package:sound/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GlobalUserViewModel globalUserViewModel = GlobalUserViewModel();
  final AuthViewModel authViewModel =
      AuthViewModel(globalUserViewModel: globalUserViewModel);
  await dotenv.load(fileName: ".env");
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
        theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
        debugShowCheckedModeBanner: false,
        home:
            authViewModel.isLoggedIn ? const EntryPoint() : const StartScreen(),
      ),
    );
  }
}
