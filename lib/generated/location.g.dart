// GENERATED CODE - DO NOT MODIFY BY HAND

part of "../location.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationPoint _$LocationPointFromJson(Map<String, dynamic> json) =>
    LocationPoint(
      json["name"] as String,
      json["capital"] as String,
      json["description"] as String,
      json["position"] as String,
      json["imageUrl"] as String,
    );

Map<String, dynamic> _$LocationPointToJson(LocationPoint instance) =>
    <String, dynamic>{
      "name": instance.name,
      "capital": instance.capital,
      "description": instance.description,
      "position": instance.position,
      "imageUrl": instance.imageUrl,
    };
