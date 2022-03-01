import "dart:convert";

import "package:flutter/services.dart";
import "package:json_annotation/json_annotation.dart";
import "package:mobile_labs/settings.dart";

part "generated/strings.g.dart";

@JsonSerializable()
class Strings {
  Strings(this.name, this.appTitle, this.launch, this.select, this.list,
    this.map, this.search, this.close, this.options, this.fontSize,
    this.fontColor, this.language, this.nightMode, this.about, this.developer);

  String name;
  String appTitle;
  String launch;
  String select;
  String list;
  String map;
  String search;
  String close;
  String options;
  String fontSize;
  String fontColor;
  String language;
  String nightMode;
  String about;
  String developer;

  factory Strings.fromJson(Map<String, dynamic> json) => _$StringsFromJson(json);
  Map<String, dynamic> toJson() => _$StringsToJson(this);
}

late List<Strings> allLocalisations;
late Strings currentLocalisation;

Future<void> loadLocalisations() async {
  String text = await rootBundle.loadString("./assets/localisations.json");
  Map<String, dynamic> locs = jsonDecode(text);
  allLocalisations = [];
  for (var entry in locs.entries) {
    allLocalisations.add(Strings.fromJson(entry.value));
  }
  currentLocalisation = allLocalisations.firstWhere((element) => element.name == settings.lang);
}