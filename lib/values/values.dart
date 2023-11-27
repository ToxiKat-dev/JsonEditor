import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> useSystemTheme = ValueNotifier<bool>(true);
ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);
ValueNotifier<String> jsonPath = ValueNotifier<String>("");

void initValues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  useSystemTheme.value = prefs.getBool("useSystemTheme") ?? true;
  isDarkTheme.value = prefs.getBool("isDarkTheme") ?? false;
  jsonPath.value = prefs.getString("jsonPath") ?? "";

  useSystemTheme.addListener(
    () async {
      await prefs.setBool("useSystemTheme", useSystemTheme.value);
    },
  );
  isDarkTheme.addListener(
    () async {
      await prefs.setBool("isDarkTheme", isDarkTheme.value);
    },
  );
  jsonPath.addListener(
    () async {
      await prefs.setString("jsonPath", jsonPath.value);
    },
  );
}

void deletevalues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  initValues();
}

Future<List> getJsonValues() async {
  if (jsonPath.value.isNotEmpty) {
    List out = [];
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    for (MapEntry entry in jsonData.entries) {
      out.add({"key": entry.key, "value": entry.value});
    }
    return out;
  } else {
    return [];
  }
}

void saveJsonValues(Map outJson) async {
  if (jsonPath.value.isNotEmpty) {
    JsonEncoder encoder = const JsonEncoder.withIndent("  ");
    String dumpJson = encoder.convert(outJson);
    await File(jsonPath.value).writeAsString(dumpJson);
  }
}

Future<void> addJsonKeyValues(String key, String value) async {
  if (jsonPath.value.isNotEmpty) {
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    jsonData[key] = value;
    JsonEncoder encoder = const JsonEncoder.withIndent("  ");
    String dumpJson = encoder.convert(jsonData);
    await File(jsonPath.value).writeAsString(dumpJson);
  }
}
