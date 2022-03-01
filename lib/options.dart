import "package:flutter/material.dart";
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:mobile_labs/app.dart";
import "package:mobile_labs/settings.dart";
import "package:mobile_labs/strings.dart";
import "package:mobile_labs/theme.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsWidget();
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

const int minFontSize = 10;
const int maxFontSize = 30;

class _SettingsWidgetState extends State<SettingsWidget> {
  late String lang;

  @override
  void initState() {
    lang = settings.lang;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Divider(),
                  Center(
                      child: Text(
                          currentLocalisation.fontSize +
                              " " +
                              settings.fontSize.toString(),
                          style: getTextStyle())),
                  Slider(
                    min: minFontSize.toDouble(),
                    max: maxFontSize.toDouble(),
                    value: (settings.fontSize.toDouble()),
                    onChanged: (value) {
                      setState(() {
                        settings.fontSize = value.toInt();
                      });
                      Future(() async {
                        await saveSettings();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Divider(),
                  Center(
                    child: Text(currentLocalisation.fontColor,
                        style: getTextStyle()),
                  ),
                  TextButton(
                    child:
                        Text(currentLocalisation.select, style: getTextStyle()),
                    onPressed: () {
                      Color pickerColor = getColor();

                      void changeColor(Color color) {
                        pickerColor = color;
                        settings.fontColorR = color.red;
                        settings.fontColorG = color.green;
                        settings.fontColorB = color.blue;
                      }

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(currentLocalisation.select,
                                  style: getTextStyle()),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                                // Use Material color picker:
                                //
                                //child: MaterialPicker (
                                //  pickerColor: pickerColor,
                                //  onColorChanged: changeColor,
                                //  showLabel: true, // only on portrait mode
                                //),
                                //
                                // Use Block color picker:
                                //
                                // child: BlockPicker(
                                //   pickerColor: currentColor,
                                //   onColorChanged: changeColor,
                                // ),
                                //
                                // child: MultipleChoiceBlockPicker(
                                //   pickerColors: currentColors,
                                //   onColorsChanged: changeColors,
                                // ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text(currentLocalisation.select,
                                      style: getTextStyle()),
                                  onPressed: () {
                                    setState(() {
                                      settings.fontColorR = pickerColor.red;
                                      settings.fontColorG = pickerColor.green;
                                      settings.fontColorB = pickerColor.blue;
                                      Future(() async {
                                        await saveSettings();
                                      });
                                    });
                                    reloadApp(context,
                                        activePage:
                                            SelectedView.options); // ???
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ],
          ),
          const Divider(thickness: 2),
          Column(
            children: [
              Text(currentLocalisation.language, style: getTextStyle()),
              DropdownButton<String>(
                value: settings.lang,
                items: List.generate(allLocalisations.length,
                        (index) => allLocalisations[index].name)
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e, style: getTextStyle()),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (element) {
                  setState(() {
                    settings.lang = element!;
                    currentLocalisation = allLocalisations
                        .firstWhere((element) => element.name == settings.lang);
                  });
                  Future(() async {
                    await saveSettings();
                  });
                  reloadApp(context, activePage: SelectedView.options);
                },
              ),
            ],
          ),
          const Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentLocalisation.nightMode, style: getTextStyle()),
              IconButton(
                icon: Icon(Icons.mode_night_outlined,
                    color: settings.nightMode ? Colors.white : Colors.black),
                onPressed: () {
                  settings.nightMode = !settings.nightMode;
                  Future(() async {
                    await saveSettings();
                  });
                  reloadApp(context, activePage: SelectedView.options);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
