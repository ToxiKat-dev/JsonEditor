import 'package:flutter/material.dart';
import 'package:jsoneditor/values/values.dart';
import 'package:jsoneditor/views/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initValues();
    useSystemTheme.addListener(() {
      setState(() {});
    });
    isDarkTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: useSystemTheme.value
          ? ThemeMode.system
          : isDarkTheme.value
              ? ThemeMode.dark
              : ThemeMode.light,
      title: "Firebase Automation",
      home: const HomePage(),
    );
  }
}
