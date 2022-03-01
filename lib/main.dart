import "dart:math";

import "package:flutter/material.dart";
import "package:mobile_labs/settings.dart";
import "package:mobile_labs/strings.dart";
import "package:mobile_labs/theme.dart";

import "app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!await loadSettings()) {
    setDefaultSettings();
    saveSettings();
  }
  await loadLocalisations();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: currentLocalisation.appTitle,
      theme: getTheme(),
      home: MyHomePage(title: currentLocalisation.appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentLocalisation.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            FutureBuilder(
              future: Future.delayed(
                const Duration(seconds: 3),
                () async {
                  _controller.stop(canceled: true);
                  reloadApp(context);
                },
              ),
              builder: (context, snapshot) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _controller.value,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Column(children: [
                      Center(
                        child: Image.asset(
                          "./assets/lime-travel.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
            AnimatedBuilder(
                child: Text(
                  currentLocalisation.developer,
                  style: getTextStyle(),
                  textAlign: TextAlign.center,
                ),
                animation: _controller,
                builder: (context, child) {
                  Offset? offset = Offset.lerp(
                      Offset.zero,
                      const Offset(0, -50),
                      (cos(_controller.value * 2 * pi) + 1) / 2);

                  return Transform.translate(offset: offset!, child: child);
                })
          ],
        ),
      ),
    );
  }
}
