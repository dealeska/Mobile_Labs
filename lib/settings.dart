import "dart:convert";
import "dart:io";

import "package:json_annotation/json_annotation.dart";
import "package:path_provider/path_provider.dart";

part "generated/settings.g.dart";

@JsonSerializable()
class Settings {
  Settings(this.fontSize, this.fontColorR, this.fontColorG, this.fontColorB,
    this.lang, this.nightMode);

  int fontSize;
  int fontColorR;
  int fontColorG;
  int fontColorB;
  String lang;
  bool nightMode;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

late Settings settings;

Future<File> _getSettingsFile() async {
  var dir = await getApplicationDocumentsDirectory();
  File file = File (dir.path + "strings.json");

  return file;
}

Future<bool> loadSettings() async {
  File file = await _getSettingsFile();
  if (await file.exists()) {
    String text = await file.readAsString();
    settings = Settings.fromJson(jsonDecode(text));

    return true;
  }
  
  return false;
}

Future saveSettings() async {
  File file = await _getSettingsFile();
  if (!await file.exists()) {
    await file.create();
  }
  String text = jsonEncode(settings.toJson());
  await file.writeAsString(text);
}

void setDefaultSettings() {
  settings = Settings(22, 0, 0, 0, "en", false);
}