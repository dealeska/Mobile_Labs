import "package:flutter/material.dart";
import "package:mobile_labs/events.dart";
import "package:mobile_labs/location.dart";
import "package:mobile_labs/settings.dart";
import "package:mobile_labs/theme.dart";
import "package:mobile_labs/zoom.dart";

class CountryInfoWidget extends StatelessWidget {
  const CountryInfoWidget(this.country, this.listener, {Key? key})
      : super(key: key);

  final LocationPoint country;
  final void Function(Action<Intent>) listener;

  @override
  Widget build(BuildContext context) {
    List<String> parts = country.position.split(", ");
    double latitude = double.parse(parts[0]);
    double longitude = double.parse(parts[1]);
    int precision = 4;
    String coords = "lat: " +
        latitude.toStringAsFixed(precision) +
        ", lng: " +
        longitude.toStringAsFixed(precision);
    String weather = country.weather.weatherMain! +
        (country.weather.temperature!.celsius!.toInt()).toString() +
        "°C";
    String title = country.name + " (" + weather + " )";

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: FittedBox(
                child: GestureDetector(
                  child: Hero(
                    tag: country.imageUrl,
                    child: Image.network(
                      country.imageUrl,
                      width: 100,
                      height: 100,
                      cacheWidth: 100,
                      cacheHeight: 100,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ZoomImageWidget(country.imageUrl);
                    }));
                  },
                ),
              ),
              onTap: () {
                /*showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text (country.name + ", " + country.capital),
                      children: [
                        ListTile (
                          leading: Image.network(country.imageUrl),
                          title: Text (country.description),
                          subtitle: Text (country.position),
                        )
                      ]
                    );
                  }
                );*/
                listener.call(LocationSelectedAction(country));
              },
              title: /*Text (
                title,
                style: TextStyle (
                  fontSize: settings.fontSize.toDouble(),
                  color: getColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),*/
                  RichText(
                      text: TextSpan(children: [
                TextSpan(
                  text: title + '\n',
                  style: TextStyle(
                    fontSize: settings.fontSize.toDouble(),
                    color: getColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: coords,
                  style: getTextStyle(),
                )
              ])),
              subtitle: Text(country.description, style: getTextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}
