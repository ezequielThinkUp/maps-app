// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectionsModel _$DirectionsModelFromJson(Map<String, dynamic> json) =>
    DirectionsModel(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => WaypointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as String,
      uuid: json['uuid'] as String,
    );

Map<String, dynamic> _$DirectionsModelToJson(DirectionsModel instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'waypoints': instance.waypoints,
      'code': instance.code,
      'uuid': instance.uuid,
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
      weightName: json['weight_name'] as String,
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      legs: (json['legs'] as List<dynamic>)
          .map((e) => LegModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      geometry: json['geometry'] as String,
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'weight_name': instance.weightName,
      'weight': instance.weight,
      'duration': instance.duration,
      'distance': instance.distance,
      'legs': instance.legs,
      'geometry': instance.geometry,
    };

LegModel _$LegModelFromJson(Map<String, dynamic> json) => LegModel(
      viaWaypoints: json['via_waypoints'] as List<dynamic>,
      admins: (json['admins'] as List<dynamic>)
          .map((e) => AdminModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      steps: json['steps'] as List<dynamic>,
      distance: (json['distance'] as num).toDouble(),
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$LegModelToJson(LegModel instance) => <String, dynamic>{
      'via_waypoints': instance.viaWaypoints,
      'admins': instance.admins,
      'weight': instance.weight,
      'duration': instance.duration,
      'steps': instance.steps,
      'distance': instance.distance,
      'summary': instance.summary,
    };

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      iso31661Alpha3: json['iso_3166_1_alpha3'] as String,
      iso31661: json['iso_3166_1'] as String,
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) =>
    <String, dynamic>{
      'iso_3166_1_alpha3': instance.iso31661Alpha3,
      'iso_3166_1': instance.iso31661,
    };

WaypointModel _$WaypointModelFromJson(Map<String, dynamic> json) =>
    WaypointModel(
      distance: (json['distance'] as num).toDouble(),
      name: json['name'] as String,
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$WaypointModelToJson(WaypointModel instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'name': instance.name,
      'location': instance.location,
    };
