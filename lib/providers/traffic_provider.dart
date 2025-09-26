import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/traffic_service.dart';
import '../models/models.dart';

final trafficServiceProvider = Provider<TrafficService>((ref) {
  return TrafficService();
});

final directionsProvider =
    FutureProvider.family<DirectionsModel?, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final trafficService = ref.watch(trafficServiceProvider);

      try {
        final origin = params['origin'] as String;
        final destination = params['destination'] as String;
        final profile = params['profile'] as String? ?? 'driving';
        final alternatives = params['alternatives'] as bool? ?? true;
        final geometries = params['geometries'] as String? ?? 'polyline6';
        final overview = params['overview'] as String? ?? 'simplified';
        final steps = params['steps'] as bool? ?? false;

        return await trafficService.getDirections(
          origin: origin,
          destination: destination,
          profile: profile,
          alternatives: alternatives,
          geometries: geometries,
          overview: overview,
          steps: steps,
        );
      } catch (e) {
        throw Exception('Error al obtener direcciones: $e');
      }
    });

final directionsFromLatLngProvider =
    FutureProvider.family<DirectionsModel?, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final trafficService = ref.watch(trafficServiceProvider);

      try {
        final originLat = params['originLat'] as double;
        final originLng = params['originLng'] as double;
        final destLat = params['destLat'] as double;
        final destLng = params['destLng'] as double;
        final profile = params['profile'] as String? ?? 'driving';
        final alternatives = params['alternatives'] as bool? ?? true;
        final geometries = params['geometries'] as String? ?? 'polyline6';
        final overview = params['overview'] as String? ?? 'simplified';
        final steps = params['steps'] as bool? ?? false;

        return await trafficService.getDirectionsFromLatLng(
          originLat: originLat,
          originLng: originLng,
          destLat: destLat,
          destLng: destLng,
          profile: profile,
          alternatives: alternatives,
          geometries: geometries,
          overview: overview,
          steps: steps,
        );
      } catch (e) {
        throw Exception('Error al obtener direcciones: $e');
      }
    });

final trafficOptimizedDirectionsProvider =
    FutureProvider.family<DirectionsModel?, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final trafficService = ref.watch(trafficServiceProvider);

      try {
        final origin = params['origin'] as String;
        final destination = params['destination'] as String;
        final alternatives = params['alternatives'] as bool? ?? true;
        final geometries = params['geometries'] as String? ?? 'polyline6';
        final overview = params['overview'] as String? ?? 'full';
        final steps = params['steps'] as bool? ?? true;

        return await trafficService.getTrafficOptimizedDirections(
          origin: origin,
          destination: destination,
          alternatives: alternatives,
          geometries: geometries,
          overview: overview,
          steps: steps,
        );
      } catch (e) {
        throw Exception('Error al obtener direcciones optimizadas: $e');
      }
    });
