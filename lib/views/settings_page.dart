import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jsoneditor/values/values.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    useSystemTheme.addListener(() {
      try {
        setState(() {});
      } finally {}
    });
    isDarkTheme.addListener(() {
      try {
        setState(() {});
      } finally {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Follow System Theme"),
            trailing: Switch(
              value: useSystemTheme.value,
              onChanged: (value) {
                useSystemTheme.value = value;
              },
            ),
          ),
          ListTile(
            title: const Text("Dark Theme"),
            trailing: Switch(
              value: isDarkTheme.value,
              onChanged: (value) {
                isDarkTheme.value = value;
              },
            ),
          ),
          ListTile(
            title: const Text("Json Path"),
            trailing: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              )),
              onPressed: selectjsonfile,
              child: const Text("Set Path"),
            ),
          ),
          ListTile(
            title: const Text("Reset Settings"),
            trailing: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              )),
              onPressed: deletevalues,
              child: const Text("Clear"),
            ),
          ),
        ],
      ),
    );
  }

  void selectjsonfile() async {
    FilePickerResult? jsonFile = await FilePicker.platform.pickFiles();
    if (jsonFile != null) {
      jsonPath.value = jsonFile.files.single.path ?? "";
      print(jsonPath.value);
    }
  }
}
