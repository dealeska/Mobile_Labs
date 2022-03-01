import "package:flutter/material.dart";
import "package:mobile_labs/cloud.dart";
import "package:mobile_labs/theme.dart";

class MySearchDelegate extends SearchDelegate<String> {
  MySearchDelegate(this.database, this.searchText);

  final CloudDatabase database;
  final String searchText;

  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.close),
    onPressed: () => Navigator.of(context).pop(),
  );

  @override
  Widget buildResults(BuildContext context) {
    return ListView (
      children: database.countries(searchText).map(
          (e) => Text (e.name, style: getTextStyle())
        ).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView (
      children: database.countries(searchText).map(
          (e) => Text (e.name)
        ).toList(),
    );
  }
}