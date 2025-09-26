import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/maps_config.dart';
import '../models/search_result.dart';

class PlacesService {
  final Dio _dio;
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  PlacesService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<SearchResult>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': MapsConfig.googleMapsApiKey,
          'types': 'geocode|establishment',
          'language': 'es',
        },
      );

      if (response.statusCode == 200) {
        final predictions = response.data['predictions'] as List;
        final results = <SearchResult>[];

        for (final prediction in predictions) {
          final placeId = prediction['place_id'] as String;
          final details = await getPlaceDetails(placeId);

          if (details != null) {
            results.add(details);
          }
        }

        return results;
      }

      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  Future<SearchResult?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': MapsConfig.googleMapsApiKey,
          'fields': 'name,formatted_address,geometry',
        },
      );

      if (response.statusCode == 200 && response.data['result'] != null) {
        final result = response.data['result'];
        final location = result['geometry']['location'];
        final formattedAddress = result['formatted_address'] as String;

        return SearchResult(
          name: result['name'] as String,
          address: formattedAddress,
          location: LatLng(
            (location['lat'] as num).toDouble(),
            (location['lng'] as num).toDouble(),
          ),
          placeId: placeId,
          formattedAddress: formattedAddress,
        );
      }

      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }
}
