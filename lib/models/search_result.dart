import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'lat_lng_converter.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String name,
    required String address,
    @LatLngConverter() required LatLng location,
    String? placeId,
    String? icon,
    double? rating,
    int? userRatingsTotal,
    String? types,
    bool? isOpenNow,
    String? priceLevel,
    String? vicinity,
    String? formattedAddress,
    String? internationalPhoneNumber,
    String? website,
    String? url,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
