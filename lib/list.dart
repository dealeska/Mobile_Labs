import "package:flutter/material.dart";
import "package:mobile_labs/cloud.dart";
import "package:mobile_labs/country.dart";

class ListWidget extends StatefulWidget {
  const ListWidget(this.searchText, this.database, this.listener, { Key? key }) : super(key: key);

  final String searchText;
  final CloudDatabase database;
  final void Function(Action<Intent>) listener;

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {

  int selectedCountry = -1;

  List<Widget> getItems() {
    return widget.database.countries(widget.searchText).map(
      (country) => CountryInfoWidget(country, widget.listener)
    ).toList();
    /*int index = 0;

    return widget.database.countries(widget.searchText).map(
      (country) {
        return ExpansionPanel (
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) {
            return Text (country.name);
          },
          body: Text (country.name),//CountryInfoWidget (country),
          isExpanded: selectedCountry == index++,
        );
      }
    ).toList();*/
  }

  @override
  Widget build(BuildContext context) {
    return ListView (
      padding: const EdgeInsets.all(10),
      children: getItems(),
    );
    /*return SingleChildScrollView (
      child: ExpansionPanelList (
        children: getItems(),
        expansionCallback: (index, isExpanded) {
          setState(() {
            if (isExpanded) {
              selectedCountry = index + 1;
            } else {
              selectedCountry = -1;
            }
            widget.listener.call(MyAction());
          });
        },
      ),
    );*/
  }

}