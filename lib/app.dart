import "package:flutter/material.dart";
import "package:mobile_labs/cloud.dart";
import "package:mobile_labs/dev.dart";
import "package:mobile_labs/events.dart";
import "package:mobile_labs/list.dart";
import "package:mobile_labs/location.dart";
import "package:mobile_labs/map.dart";
import "package:mobile_labs/options.dart";
import "package:mobile_labs/settings.dart";
import "package:mobile_labs/strings.dart";
import "package:mobile_labs/theme.dart";

class AppScreenWidget extends StatelessWidget {
  const AppScreenWidget(this.activePage, {Key? key}) : super(key: key);

  final SelectedView activePage;

  @override
  Widget build(BuildContext context) {
    return AppSelectorWidget(activePage);
  }
}

class AppSelectorWidget extends StatefulWidget {
  const AppSelectorWidget(this.activePage, {Key? key}) : super(key: key);

  final SelectedView activePage;

  @override
  _AppSelectorWidgetState createState() => _AppSelectorWidgetState();
}

class _AppSelectorWidgetState extends State<AppSelectorWidget> {
  String searchText = "";
  bool typing = false;

  LocationPoint? selectedPoint;

  late SelectedView currentState;
  late CloudDatabase database;
  late void Function(Action<Intent>) listener;

  BottomNavigationBar getNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.language),
          label: currentLocalisation.list,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.location_pin),
          label: currentLocalisation.map,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: currentLocalisation.options,
        ),
      ],
      currentIndex: currentState.index,
      onTap: (index) {
        switch (index) {
          case 0:
            setState(() {
              currentState = SelectedView.list;
            });
            break;
          case 1:
            setState(() {
              currentState = SelectedView.map;
            });
            break;
          case 2:
            setState(() {
              currentState = SelectedView.options;
            });
            break;
        }
      },
    );
  }

  Widget getTitle() {
    switch (currentState) {
      case SelectedView.list:
        var controller = TextEditingController();
        controller.text = searchText;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));

        return TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: currentLocalisation.search,
          ),
          showCursor: true,
          onTap: () {
            setState(() {
              typing = true;
            });
          },
          onChanged: (value) {
            setState(() {
              searchText = value.toLowerCase();
            });
          },
          onSubmitted: (value) {
            setState(() {
              typing = false;
            });
          },
        );
      case SelectedView.map:
        return Text(currentLocalisation.map,
            style: TextStyle(color: getColor()));
      case SelectedView.options:
        return Text(currentLocalisation.options,
            style: TextStyle(color: getColor()));
    }
  }

  Widget getBody() {
    return ActionListener(
      action: LocationSelectedAction(null),
      listener: listener = (action) {
        setState(() {
          if (action is LocationSelectedAction) {
            LocationPoint? point = (action).point;
            if (point != null) {
              selectedPoint = point;
              currentState = SelectedView.map;
            }
          }
        });
      },
      child: FutureBuilder<bool>(
        future: Future(() async {
          if (!database.initialized) {
            await database.init(listener);
          }

          return true;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (currentState) {
              case SelectedView.list:
                return ListWidget(searchText, database, listener);
              case SelectedView.map:
                return MapWidget(database, listener, selectedPoint);
              case SelectedView.options:
                return const SettingsWidget();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.lightBlue,
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> getActions() {
    List<Widget> result = [];

    if (typing) {
    } else {
      result.add(IconButton(
        icon: const Icon(Icons.info),
        onPressed: () {
          aboutDev();
        },
      ));
    }

    return result;
  }

  void aboutDev() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const InfoPage();
    }));
  }

  @override
  void initState() {
    currentState = widget.activePage;

    database = CloudDatabase();
    database.initialized = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: currentLocalisation.appTitle,
      theme: getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: getTitle(),
          actions: getActions(),
        ),
        backgroundColor: settings.nightMode ? Colors.black : Colors.white,
        body: getBody(),
        bottomNavigationBar: getNavigationBar(),
        //floatingActionButton: getFloatingButton(),
      ),
    );
  }
}

void reloadApp(BuildContext context, {SelectedView? activePage}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return AppScreenWidget(activePage ?? SelectedView.list);
      },
    ),
  );
}

enum SelectedView {
  list,
  map,
  options,
}
