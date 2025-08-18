// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  @LatLngConverter()
  LatLng get location => throw _privateConstructorUsedError;
  String? get placeId => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get userRatingsTotal => throw _privateConstructorUsedError;
  String? get types => throw _privateConstructorUsedError;
  bool? get isOpenNow => throw _privateConstructorUsedError;
  String? get priceLevel => throw _privateConstructorUsedError;
  String? get vicinity => throw _privateConstructorUsedError;
  String? get formattedAddress => throw _privateConstructorUsedError;
  String? get internationalPhoneNumber => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
    SearchResult value,
    $Res Function(SearchResult) then,
  ) = _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call({
    String name,
    String address,
    @LatLngConverter() LatLng location,
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
  });
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? placeId = freezed,
    Object? icon = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? types = freezed,
    Object? isOpenNow = freezed,
    Object? priceLevel = freezed,
    Object? vicinity = freezed,
    Object? formattedAddress = freezed,
    Object? internationalPhoneNumber = freezed,
    Object? website = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as LatLng,
            placeId: freezed == placeId
                ? _value.placeId
                : placeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            userRatingsTotal: freezed == userRatingsTotal
                ? _value.userRatingsTotal
                : userRatingsTotal // ignore: cast_nullable_to_non_nullable
                      as int?,
            types: freezed == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOpenNow: freezed == isOpenNow
                ? _value.isOpenNow
                : isOpenNow // ignore: cast_nullable_to_non_nullable
                      as bool?,
            priceLevel: freezed == priceLevel
                ? _value.priceLevel
                : priceLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            vicinity: freezed == vicinity
                ? _value.vicinity
                : vicinity // ignore: cast_nullable_to_non_nullable
                      as String?,
            formattedAddress: freezed == formattedAddress
                ? _value.formattedAddress
                : formattedAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            internationalPhoneNumber: freezed == internationalPhoneNumber
                ? _value.internationalPhoneNumber
                : internationalPhoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
    _$SearchResultImpl value,
    $Res Function(_$SearchResultImpl) then,
  ) = __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String address,
    @LatLngConverter() LatLng location,
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
  });
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
    _$SearchResultImpl _value,
    $Res Function(_$SearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? placeId = freezed,
    Object? icon = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? types = freezed,
    Object? isOpenNow = freezed,
    Object? priceLevel = freezed,
    Object? vicinity = freezed,
    Object? formattedAddress = freezed,
    Object? internationalPhoneNumber = freezed,
    Object? website = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _$SearchResultImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LatLng,
        placeId: freezed == placeId
            ? _value.placeId
            : placeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        userRatingsTotal: freezed == userRatingsTotal
            ? _value.userRatingsTotal
            : userRatingsTotal // ignore: cast_nullable_to_non_nullable
                  as int?,
        types: freezed == types
            ? _value.types
            : types // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOpenNow: freezed == isOpenNow
            ? _value.isOpenNow
            : isOpenNow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        priceLevel: freezed == priceLevel
            ? _value.priceLevel
            : priceLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        vicinity: freezed == vicinity
            ? _value.vicinity
            : vicinity // ignore: cast_nullable_to_non_nullable
                  as String?,
        formattedAddress: freezed == formattedAddress
            ? _value.formattedAddress
            : formattedAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        internationalPhoneNumber: freezed == internationalPhoneNumber
            ? _value.internationalPhoneNumber
            : internationalPhoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl({
    required this.name,
    required this.address,
    @LatLngConverter() required this.location,
    this.placeId,
    this.icon,
    this.rating,
    this.userRatingsTotal,
    this.types,
    this.isOpenNow,
    this.priceLevel,
    this.vicinity,
    this.formattedAddress,
    this.internationalPhoneNumber,
    this.website,
    this.url,
  });

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  @override
  final String name;
  @override
  final String address;
  @override
  @LatLngConverter()
  final LatLng location;
  @override
  final String? placeId;
  @override
  final String? icon;
  @override
  final double? rating;
  @override
  final int? userRatingsTotal;
  @override
  final String? types;
  @override
  final bool? isOpenNow;
  @override
  final String? priceLevel;
  @override
  final String? vicinity;
  @override
  final String? formattedAddress;
  @override
  final String? internationalPhoneNumber;
  @override
  final String? website;
  @override
  final String? url;

  @override
  String toString() {
    return 'SearchResult(name: $name, address: $address, location: $location, placeId: $placeId, icon: $icon, rating: $rating, userRatingsTotal: $userRatingsTotal, types: $types, isOpenNow: $isOpenNow, priceLevel: $priceLevel, vicinity: $vicinity, formattedAddress: $formattedAddress, internationalPhoneNumber: $internationalPhoneNumber, website: $website, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.userRatingsTotal, userRatingsTotal) ||
                other.userRatingsTotal == userRatingsTotal) &&
            (identical(other.types, types) || other.types == types) &&
            (identical(other.isOpenNow, isOpenNow) ||
                other.isOpenNow == isOpenNow) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            (identical(other.vicinity, vicinity) ||
                other.vicinity == vicinity) &&
            (identical(other.formattedAddress, formattedAddress) ||
                other.formattedAddress == formattedAddress) &&
            (identical(
                  other.internationalPhoneNumber,
                  internationalPhoneNumber,
                ) ||
                other.internationalPhoneNumber == internationalPhoneNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    address,
    location,
    placeId,
    icon,
    rating,
    userRatingsTotal,
    types,
    isOpenNow,
    priceLevel,
    vicinity,
    formattedAddress,
    internationalPhoneNumber,
    website,
    url,
  );

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(this);
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult({
    required final String name,
    required final String address,
    @LatLngConverter() required final LatLng location,
    final String? placeId,
    final String? icon,
    final double? rating,
    final int? userRatingsTotal,
    final String? types,
    final bool? isOpenNow,
    final String? priceLevel,
    final String? vicinity,
    final String? formattedAddress,
    final String? internationalPhoneNumber,
    final String? website,
    final String? url,
  }) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override
  String get name;
  @override
  String get address;
  @override
  @LatLngConverter()
  LatLng get location;
  @override
  String? get placeId;
  @override
  String? get icon;
  @override
  double? get rating;
  @override
  int? get userRatingsTotal;
  @override
  String? get types;
  @override
  bool? get isOpenNow;
  @override
  String? get priceLevel;
  @override
  String? get vicinity;
  @override
  String? get formattedAddress;
  @override
  String? get internationalPhoneNumber;
  @override
  String? get website;
  @override
  String? get url;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
