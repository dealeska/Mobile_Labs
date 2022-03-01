// GENERATED CODE - DO NOT MODIFY BY HAND

part of "../settings.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      json["fontSize"] as int,
      json["fontColorR"] as int,
      json["fontColorG"] as int,
      json["fontColorB"] as int,
      json["lang"] as String,
      json["nightMode"] as bool,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      "fontSize": instance.fontSize,
      "fontColorR": instance.fontColorR,
      "fontColorG": instance.fontColorG,
      "fontColorB": instance.fontColorB,
      "lang": instance.lang,
      "nightMode": instance.nightMode,
    };
