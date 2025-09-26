// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      name: json['name'] as String,
      address: json['address'] as String,
      location: const LatLngConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      placeId: json['placeId'] as String?,
      icon: json['icon'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: (json['userRatingsTotal'] as num?)?.toInt(),
      types: json['types'] as String?,
      isOpenNow: json['isOpenNow'] as bool?,
      priceLevel: json['priceLevel'] as String?,
      vicinity: json['vicinity'] as String?,
      formattedAddress: json['formattedAddress'] as String?,
      internationalPhoneNumber: json['internationalPhoneNumber'] as String?,
      website: json['website'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'location': const LatLngConverter().toJson(instance.location),
      'placeId': instance.placeId,
      'icon': instance.icon,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'types': instance.types,
      'isOpenNow': instance.isOpenNow,
      'priceLevel': instance.priceLevel,
      'vicinity': instance.vicinity,
      'formattedAddress': instance.formattedAddress,
      'internationalPhoneNumber': instance.internationalPhoneNumber,
      'website': instance.website,
      'url': instance.url,
    };
