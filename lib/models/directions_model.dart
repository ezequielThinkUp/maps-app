import 'package:json_annotation/json_annotation.dart';

part 'directions_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DirectionsModel {
  final List<RouteModel> routes;
  final List<WaypointModel> waypoints;
  final String code;
  final String uuid;

  DirectionsModel({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  factory DirectionsModel.fromJson(Map<String, dynamic> json) =>
      _$DirectionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DirectionsModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RouteModel {
  final String weightName;
  final double weight;
  final double duration;
  final double distance;
  final List<LegModel> legs;
  final String geometry;

  RouteModel({
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LegModel {
  final List<dynamic> viaWaypoints;
  final List<AdminModel> admins;
  final double weight;
  final double duration;
  final List<dynamic> steps;
  final double distance;
  final String summary;

  LegModel({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  factory LegModel.fromJson(Map<String, dynamic> json) =>
      _$LegModelFromJson(json);

  Map<String, dynamic> toJson() => _$LegModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminModel {
  @JsonKey(name: 'iso_3166_1_alpha3')
  final String iso31661Alpha3;
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;

  AdminModel({required this.iso31661Alpha3, required this.iso31661});

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WaypointModel {
  final double distance;
  final String name;
  final List<double> location;

  WaypointModel({
    required this.distance,
    required this.name,
    required this.location,
  });

  factory WaypointModel.fromJson(Map<String, dynamic> json) =>
      _$WaypointModelFromJson(json);

  Map<String, dynamic> toJson() => _$WaypointModelToJson(this);
}
