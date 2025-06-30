import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rag_rang_app/notifiers.dart';
import 'package:rag_rang_app/pages/welcome_page.dart';
import 'package:rag_rang_app/widgets/like_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Make sure this line runs **before** the box is opened anywhere
  await Hive.deleteBoxFromDisk('liked_songs');

  await LikeStorage.init();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  Future<void> _initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isBright = prefs.getBool('theme_mode') ?? false;
    isbrightNotifier.value = isBright;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isbrightNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: mode ? Brightness.light : Brightness.dark,
            ),
          ),
          home: const WelcomePage(),
        );
      },
    );
  }
}
