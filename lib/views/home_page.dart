import 'package:flutter/material.dart';
import 'package:jsoneditor/values/values.dart';
import 'package:jsoneditor/views/editor_view.dart';
import 'package:jsoneditor/views/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JSON Editor"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: getwidgets(),
    );
  }

  Widget getwidgets() {
    jsonPath.addListener(() {
      setState(() {});
    });
    if (jsonPath.value.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Set the Path to the json file"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getJsonPath,
              child: Text("Set Path"),
            ),
          ],
        ),
      );
    } else {
      return const Editingview();
    }
  }
}
