import 'package:flutter/material.dart';
import 'package:rag_rang_app/notifiers.dart';
import 'package:rag_rang_app/pages/home_page.dart';
import 'package:rag_rang_app/pages/welcome_page.dart';
import 'package:rag_rang_app/widgets/navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // async ka wait karne ke liye
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? theme = prefs.getBool(kconstants.themeModekey);
  isbrightNotifier.value = theme ?? false;

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //
  //   intheme();
  //
  //   super.initState();
  //
  // }
  // void intheme() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final bool? repeat = prefs.getBool(kconstants.themeModekey);
  //   isbrightNotifier.value = repeat ?? false;
  // }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(valueListenable: isbrightNotifier, builder: (context, mode, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: mode ? Brightness.light : Brightness.dark,

        ),

        ),

        home: WelcomePage(),

      );
    },
    );
  }
}
