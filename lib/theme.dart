import "package:flutter/material.dart";
import "package:mobile_labs/settings.dart";

ThemeData getTheme() {
  return ThemeData (
    primarySwatch: Colors.blue,
    colorScheme: settings.nightMode ? const ColorScheme.dark() : const ColorScheme.light(),
  );
}

Color getColor() {
  return settings.nightMode ? Colors.white : Color.fromARGB(255, settings.fontColorR, settings.fontColorG, settings.fontColorB);
}

TextStyle getTextStyle() {
  return TextStyle (
    fontSize: settings.fontSize.toDouble(),
    color: getColor(),
  );
}