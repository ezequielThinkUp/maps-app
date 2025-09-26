import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/directions_model.dart';
import '../services/services.dart';
import 'traffic_provider.dart';

class TrafficServiceExample extends ConsumerWidget {
  const TrafficServiceExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traffic Service Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _testMapboxResponseMapping(),
              child: const Text('Test Mapbox Response Mapping'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testDirectionsProvider(ref),
              child: const Text('Test Directions Provider'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testLatLngDirections(ref),
              child: const Text('Test LatLng Directions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testTrafficOptimized(ref),
              child: const Text('Test Traffic Optimized'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testPolylineDecoder(),
              child: const Text('Test Polyline Decoder'),
            ),
          ],
        ),
      ),
    );
  }

  void _testMapboxResponseMapping() {
    // Respuesta exacta de Mapbox que proporcionaste
    const Map<String, dynamic> mapboxResponse = {
      "routes": [
        {
          "weight_name": "auto",
          "weight": 0.609,
          "duration": 0.609,
          "distance": 3.552,
          "legs": [
            {
              "via_waypoints": [],
              "admins": [
                {"iso_3166_1_alpha3": "USA", "iso_3166_1": "US"},
              ],
              "weight": 0.609,
              "duration": 0.609,
              "steps": [],
              "distance": 3.552,
              "summary": "Belgrove Drive",
            },
          ],
          "geometry": "wvowlAntsllCu@o@",
        },
      ],
      "waypoints": [
        {
          "distance": 38.516,
          "name": "Belgrove Drive",
          "location": [-74.148184, 40.771964],
        },
        {
          "distance": 18.162,
          "name": "Belgrove Drive",
          "location": [-74.14816, 40.771991],
        },
      ],
      "code": "Ok",
      "uuid": "6agLHuilrOM7hM7zvwEQiBZVNRDog3JSEI3ck4OWENAT5cwHLiOb7Q==",
    };

    try {
      // Mapear la respuesta usando nuestro modelo
      final directions = DirectionsModel.fromJson(mapboxResponse);

      print('✅ [MAPPING] Response mapped successfully!');
      print('✅ [MAPPING] Code: ${directions.code}');
      print('✅ [MAPPING] UUID: ${directions.uuid}');
      print('✅ [MAPPING] Routes count: ${directions.routes.length}');
      print('✅ [MAPPING] Waypoints count: ${directions.waypoints.length}');

      // Mostrar detalles de la primera ruta
      if (directions.routes.isNotEmpty) {
        final route = directions.routes.first;
        print('✅ [MAPPING] First route:');
        print('  - Weight name: ${route.weightName}');
        print('  - Weight: ${route.weight}');
        print('  - Duration: ${route.duration} minutes');
        print('  - Distance: ${route.distance} km');
        print('  - Geometry: ${route.geometry}');
        print('  - Legs count: ${route.legs.length}');

        // Mostrar detalles del primer leg
        if (route.legs.isNotEmpty) {
          final leg = route.legs.first;
          print('✅ [MAPPING] First leg:');
          print('  - Summary: ${leg.summary}');
          print('  - Distance: ${leg.distance} km');
          print('  - Duration: ${leg.duration} minutes');
          print('  - Admins count: ${leg.admins.length}');

          // Mostrar detalles del primer admin
          if (leg.admins.isNotEmpty) {
            final admin = leg.admins.first;
            print('✅ [MAPPING] First admin:');
            print('  - ISO 3166-1 Alpha3: ${admin.iso31661Alpha3}');
            print('  - ISO 3166-1: ${admin.iso31661}');
          }
        }
      }

      // Mostrar detalles de los waypoints
      for (int i = 0; i < directions.waypoints.length; i++) {
        final waypoint = directions.waypoints[i];
        print('✅ [MAPPING] Waypoint $i:');
        print('  - Name: ${waypoint.name}');
        print('  - Distance: ${waypoint.distance}');
        print(
          '  - Location: [${waypoint.location[0]}, ${waypoint.location[1]}]',
        );
      }

      // Convertir de vuelta a JSON para verificar
      final backToJson = directions.toJson();
      print('✅ [MAPPING] Converted back to JSON successfully');
      print('✅ [MAPPING] JSON keys: ${backToJson.keys.toList()}');
    } catch (e) {
      print('❌ [MAPPING] Error mapping response: $e');
    }
  }

  void _testDirectionsProvider(WidgetRef ref) {
    final directionsAsync = ref.read(
      directionsProvider({
        'origin': '-74.148561,40.77216',
        'destination': '-74.148338,40.772083',
        'profile': 'driving',
      }),
    );

    directionsAsync.when(
      data: (directions) {
        if (directions != null) {
          print('✅ [PROVIDER] Directions obtained:');
          print('  - Code: ${directions.code}');
          print('  - Routes: ${directions.routes.length}');
          for (int i = 0; i < directions.routes.length; i++) {
            final route = directions.routes[i];
            print('  - Route $i: ${route.distance}km, ${route.duration}min');
          }
        }
      },
      loading: () => print('⏳ [PROVIDER] Loading directions...'),
      error: (error, stack) => print('❌ [PROVIDER] Error: $error'),
    );
  }

  void _testLatLngDirections(WidgetRef ref) {
    final directionsAsync = ref.read(
      directionsFromLatLngProvider({
        'originLat': 40.77216,
        'originLng': -74.148561,
        'destLat': 40.772083,
        'destLng': -74.148338,
      }),
    );

    directionsAsync.when(
      data: (directions) {
        if (directions != null) {
          print('✅ [LATLNG] Directions from LatLng obtained:');
          print('  - Code: ${directions.code}');
          print('  - Waypoints: ${directions.waypoints.length}');
        }
      },
      loading: () => print('⏳ [LATLNG] Loading directions from LatLng...'),
      error: (error, stack) => print('❌ [LATLNG] Error: $error'),
    );
  }

  void _testTrafficOptimized(WidgetRef ref) {
    final directionsAsync = ref.read(
      trafficOptimizedDirectionsProvider({
        'origin': '-74.148561,40.77216',
        'destination': '-74.148338,40.772083',
      }),
    );

    directionsAsync.when(
      data: (directions) {
        if (directions != null) {
          print('✅ [TRAFFIC] Traffic optimized directions obtained:');
          print('  - Code: ${directions.code}');
          print('  - Routes: ${directions.routes.length}');
        }
      },
      loading: () =>
          print('⏳ [TRAFFIC] Loading traffic optimized directions...'),
      error: (error, stack) => print('❌ [TRAFFIC] Error: $error'),
    );
  }

  void _testPolylineDecoder() {
    // Polyline de ejemplo de Mapbox
    const String mapboxPolyline = "wvowlAntsllCu@o@";

    print('🧪 [POLYLINE] Testing polyline decoder...');
    print('🧪 [POLYLINE] Encoded polyline: $mapboxPolyline');

    // Decodificar polyline básico
    final points = PolylineDecoder.decodePolyline(mapboxPolyline);
    print('✅ [POLYLINE] Decoded ${points.length} points');

    for (int i = 0; i < points.length; i++) {
      print('  - Point $i: [${points[i].latitude}, ${points[i].longitude}]');
    }

    // Decodificar con estadísticas
    final stats = PolylineDecoder.decodePolylineWithStats(mapboxPolyline);
    print('📊 [POLYLINE] Statistics:');
    print('  - Point count: ${stats['pointCount']}');
    print(
      '  - Total distance: ${stats['totalDistance'].toStringAsFixed(2)} meters',
    );
    print('  - Is valid: ${stats['isValid']}');

    if (stats['startPoint'] != null) {
      print(
        '  - Start: [${stats['startPoint'].latitude}, ${stats['startPoint'].longitude}]',
      );
    }
    if (stats['endPoint'] != null) {
      print(
        '  - End: [${stats['endPoint'].latitude}, ${stats['endPoint'].longitude}]',
      );
    }

    // Validar polyline
    final isValid = PolylineDecoder.isValidPolyline(mapboxPolyline);
    print('✅ [POLYLINE] Is valid polyline: $isValid');

    // Obtener punto medio
    final midpoint = PolylineDecoder.getMidpoint(mapboxPolyline);
    if (midpoint != null) {
      print(
        '📍 [POLYLINE] Midpoint: [${midpoint.latitude}, ${midpoint.longitude}]',
      );
    }

    // Simplificar polyline
    final simplified = PolylineDecoder.simplifyPolyline(
      mapboxPolyline,
      tolerance: 5.0,
    );
    print('🔄 [POLYLINE] Simplified polyline: $simplified');

    // Decodificar múltiples polylines
    final multiplePolylines = ["wvowlAntsllCu@o@", "wvowlAntsllCu@o@"];
    final combinedPoints = PolylineDecoder.decodeMultiplePolylines(
      multiplePolylines,
    );
    print(
      '🔗 [POLYLINE] Combined ${combinedPoints.length} points from multiple polylines',
    );
  }
}
