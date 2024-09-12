import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/pages/starting_page.dart';
import 'package:sound/utils/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalUserViewModel())
      ],
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
        debugShowCheckedModeBanner: false,
        home: const StartScreen(),
      ),
    );
  }
}
