import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:mobile_labs/cloud.dart";
import "package:mobile_labs/events.dart";
import "package:mobile_labs/location.dart";
import "package:mobile_labs/strings.dart";
import "package:mobile_labs/theme.dart";
import "package:search_choices/search_choices.dart";

class MapWidget extends StatefulWidget {
  const MapWidget(this.database, this.listener, this.initiallySelectedCountry,
      {Key? key})
      : super(key: key);

  final CloudDatabase database;
  final void Function(Action<Intent>) listener;
  final LocationPoint? initiallySelectedCountry;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LocationPoint? selectedPoint;

  String searchText = "";

  late GoogleMapController _controller;
  late void Function(Action<Intent>) updatePointListener;

  Set<Marker> getMarkers() {
    return widget.database
        .countries(searchText.toLowerCase())
        .map((country) => getMarker(country))
        .toSet();
  }

  Marker findMarker(LocationPoint country) {
    return getMarkers()
        .firstWhere((marker) => marker.markerId.value == country.name);
  }

  List<DropdownMenuItem<String>> getItems() {
    return widget.database
        .countries(searchText.toLowerCase())
        .map((country) => DropdownMenuItem(
              value: country.name,
              child: Text(country.name, style: getTextStyle()),
              onTap: () {
                updatePointListener.call(LocationSelectedAction(country));
              },
            ))
        .toList();
  }

  void showPoint(LocationPoint country) {
    Marker newMarker = findMarker(country);
    _controller.showMarkerInfoWindow(newMarker.mapsId);
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: getPosition(country.position),
    )));
  }

  @override
  Widget build(BuildContext context) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

    selectedPoint = widget.initiallySelectedCountry;

    return ActionListener(
      action: LocationSelectedAction(null),
      listener: updatePointListener = (action) {
        if (action is LocationSelectedAction) {
          if (action.point != null) {
            showPoint(action.point!);
          }
        }
      },
      child: Column(
        children: [
          SearchChoices.single(
            items: getItems(),
            value: searchText,
            hint: currentLocalisation.select,
            searchHint: currentLocalisation.select,
            onChanged: (value) {
              setState(() {
                //searchText = value.toString();
              });
            },
            searchFn: (keyword, items) {
              List<int> indices = [];

              if (keyword.toString().length < 3) {
                return indices;
              }

              int index = 0;
              for (var item in items) {
                String itemStr = (item as DropdownMenuItem<String>)
                    .value
                    .toString()
                    .toLowerCase();
                String keyStr = keyword.toString().toLowerCase();
                if (itemStr.contains(keyStr)) {
                  indices.add(index);
                }
                index++;
              }

              return indices;
            },
            validator: (value) {
              if (value == null) {
                return null;
              }
              if (value is String &&
                  searchText.length >= 3 &&
                  value.contains(searchText)) {
                return value;
              } else {
                return null;
              }
            },
            isExpanded: true,
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: selectedPoint != null
                    ? getPosition(selectedPoint!.position)
                    : getPosition(widget.database.countries("")[0].position),
              ),
              markers: getMarkers(),
              onMapCreated: (controller) {
                _controller = controller;
                if (selectedPoint != null) {
                  showPoint(selectedPoint!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

LatLng getPosition(String position) {
  List<String> parts = position.split(", ");
  double latitude = double.parse(parts[0]);
  double longitude = double.parse(parts[1]);

  return LatLng(latitude, longitude);
}

InfoWindow getInfoWindow(LocationPoint country) {
  List<String> parts = country.position.split(", ");
  double latitude = double.parse(parts[0]);
  double longitude = double.parse(parts[1]);
  int precision = 4;
  String coords = latitude.toStringAsFixed(precision) +
      ", " +
      longitude.toStringAsFixed(precision);

  String title = country.name + " (" + coords + ")";
  String weather = country.weather.weatherMain! +
      ", " +
      (country.weather.temperature!.celsius!.toInt()).toString() +
      "°C";

  return InfoWindow(
    title: title,
    snippet: weather,
  );
}

Marker getMarker(LocationPoint country) {
  return Marker(
    markerId: MarkerId(country.name),
    position: getPosition(country.position),
    infoWindow: getInfoWindow(country),
  );
}
