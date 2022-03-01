import "package:json_annotation/json_annotation.dart";
import "package:weather/weather.dart";

part "generated/location.g.dart";

@JsonSerializable()
class LocationPoint {
  LocationPoint(this.name, this.capital, this.description, this.position, this.imageUrl);

  String name;
  String capital;
  String description;
  String position;
  String imageUrl;

  late Weather weather;

  factory LocationPoint.fromJson(Map<String, dynamic> json) => _$LocationPointFromJson(json);
  Map<String, dynamic> toJson() => _$LocationPointToJson(this);
}