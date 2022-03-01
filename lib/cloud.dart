import "dart:convert";
import "dart:developer";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:mobile_labs/events.dart";
import "package:mobile_labs/location.dart";
import "package:mobile_labs/map.dart";
import "package:weather/weather.dart";

class CloudDatabase {
  final List<LocationPoint> _countries = [];

  bool initialized = false;
  bool failed = false;

  Future init(void Function(Action<Intent>) listener) async {
    if (_countries.isEmpty && !initialized && !failed) {
      try {
        await Firebase.initializeApp();

        var text = await rootBundle.loadString("./assets/user.json");
        var user = jsonDecode(text);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user["email"],
          password: user["password"],
        );

        var weatherFactory =
            WeatherFactory(user["owmkey"], language: Language.ENGLISH);
        var collection = FirebaseFirestore.instance.collection("countries");

        collection.orderBy("name").snapshots().listen((event) async {
          _countries.clear();
          for (var element in event.docs) {
            var country = LocationPoint.fromJson(element.data());
            var latlng = getPosition(country.position);
            Weather weather = await weatherFactory.currentWeatherByLocation(
                latlng.latitude, latlng.longitude);
            country.weather = weather;
            _countries.add(country);
          }
          listener.call(LocationSelectedAction(null));
        });

        initialized = true;
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        failed = true;
      }
    }
  }

  List<LocationPoint> countries(String searchText) {
    if (searchText.length < 3) {
      return _countries;
    } else {
      return _countries
          .where((element) =>
              element.name.toLowerCase().contains(searchText) ||
              element.capital.toLowerCase().contains(searchText) ||
              element.description.toLowerCase().contains(searchText))
          .toList();
    }
  }
}
