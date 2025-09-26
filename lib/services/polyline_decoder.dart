import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart'
    as polyline;

class PolylineDecoder {
  /// Decodifica una geometría de polyline de Mapbox a una lista de LatLng
  ///
  /// [encodedPolyline] - La geometría codificada de Mapbox (ej: "wvowlAntsllCu@o@")
  /// [precision] - Precisión del polyline (por defecto 5 para Mapbox)
  ///
  /// Retorna una lista de LatLng que representa la ruta
  static List<LatLng> decodePolyline(
    String encodedPolyline, {
    int precision = 5,
  }) {
    try {
      // Decodificar el polyline usando el algoritmo de Google
      final List<List<num>> decodedPoints = polyline.decodePolyline(
        encodedPolyline,
      );

      // Convertir a LatLng
      final List<LatLng> latLngPoints = decodedPoints.map((point) {
        // El formato es [latitud, longitud]
        return LatLng(point[0].toDouble(), point[1].toDouble());
      }).toList();

      return latLngPoints;
    } catch (e) {
      print('❌ [POLYLINE] Error decoding polyline: $e');
      return [];
    }
  }

  /// Decodifica múltiples polylines y los combina
  ///
  /// [encodedPolylines] - Lista de geometrías codificadas
  /// [precision] - Precisión del polyline
  ///
  /// Retorna una lista combinada de LatLng
  static List<LatLng> decodeMultiplePolylines(
    List<String> encodedPolylines, {
    int precision = 5,
  }) {
    final List<LatLng> allPoints = [];

    for (final polyline in encodedPolylines) {
      final points = decodePolyline(polyline, precision: precision);
      allPoints.addAll(points);
    }

    return allPoints;
  }

  /// Decodifica un polyline y retorna información adicional
  ///
  /// [encodedPolyline] - La geometría codificada
  /// [precision] - Precisión del polyline
  ///
  /// Retorna un mapa con puntos y estadísticas
  static Map<String, dynamic> decodePolylineWithStats(
    String encodedPolyline, {
    int precision = 5,
  }) {
    try {
      final points = decodePolyline(encodedPolyline, precision: precision);

      if (points.isEmpty) {
        return {
          'points': [],
          'pointCount': 0,
          'totalDistance': 0.0,
          'isValid': false,
          'error': 'No points decoded',
        };
      }

      // Calcular distancia total
      double totalDistance = 0.0;
      for (int i = 0; i < points.length - 1; i++) {
        totalDistance += _calculateDistance(points[i], points[i + 1]);
      }

      return {
        'points': points,
        'pointCount': points.length,
        'totalDistance': totalDistance,
        'isValid': true,
        'startPoint': points.first,
        'endPoint': points.last,
        'bounds': _calculateBounds(points),
      };
    } catch (e) {
      return {
        'points': [],
        'pointCount': 0,
        'totalDistance': 0.0,
        'isValid': false,
        'error': e.toString(),
      };
    }
  }

  /// Calcula la distancia entre dos puntos usando la fórmula de Haversine
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Radio de la Tierra en metros

    final double lat1Rad = point1.latitude * (pi / 180);
    final double lat2Rad = point2.latitude * (pi / 180);
    final double deltaLatRad = (point2.latitude - point1.latitude) * (pi / 180);
    final double deltaLngRad =
        (point2.longitude - point1.longitude) * (pi / 180);

    final double a =
        sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLngRad / 2) *
            sin(deltaLngRad / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calcula los límites (bounds) de una lista de puntos
  static Map<String, LatLng> _calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return {};
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return {
      'southwest': LatLng(minLat, minLng),
      'northeast': LatLng(maxLat, maxLng),
    };
  }

  /// Valida si un polyline codificado es válido
  static bool isValidPolyline(String encodedPolyline) {
    try {
      final points = decodePolyline(encodedPolyline);
      return points.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene el punto medio de un polyline
  static LatLng? getMidpoint(String encodedPolyline, {int precision = 5}) {
    try {
      final points = decodePolyline(encodedPolyline, precision: precision);

      if (points.isEmpty) return null;

      final midIndex = points.length ~/ 2;
      return points[midIndex];
    } catch (e) {
      return null;
    }
  }

  /// Simplifica un polyline reduciendo el número de puntos
  ///
  /// [encodedPolyline] - Polyline original
  /// [tolerance] - Tolerancia para simplificación (en metros)
  /// [precision] - Precisión del polyline
  ///
  /// Retorna un polyline simplificado
  static String simplifyPolyline(
    String encodedPolyline, {
    double tolerance = 10.0,
    int precision = 5,
  }) {
    try {
      final points = decodePolyline(encodedPolyline, precision: precision);

      if (points.length <= 2) return encodedPolyline;

      final simplifiedPoints = _simplifyPoints(points, tolerance);

      // Convertir de vuelta a polyline codificado
      final List<List<int>> intPoints = simplifiedPoints.map((point) {
        return [point.latitude.round(), point.longitude.round()];
      }).toList();

      return polyline.encodePolyline(intPoints);
    } catch (e) {
      print('❌ [POLYLINE] Error simplifying polyline: $e');
      return encodedPolyline;
    }
  }

  /// Algoritmo de simplificación de Douglas-Peucker
  static List<LatLng> _simplifyPoints(List<LatLng> points, double tolerance) {
    if (points.length <= 2) return points;

    double maxDistance = 0;
    int index = 0;

    final LatLng start = points.first;
    final LatLng end = points.last;

    for (int i = 1; i < points.length - 1; i++) {
      final distance = _perpendicularDistance(points[i], start, end);
      if (distance > maxDistance) {
        maxDistance = distance;
        index = i;
      }
    }

    if (maxDistance > tolerance) {
      final List<LatLng> firstHalf = _simplifyPoints(
        points.sublist(0, index + 1),
        tolerance,
      );
      final List<LatLng> secondHalf = _simplifyPoints(
        points.sublist(index),
        tolerance,
      );

      return [...firstHalf.sublist(0, firstHalf.length - 1), ...secondHalf];
    } else {
      return [start, end];
    }
  }

  /// Calcula la distancia perpendicular de un punto a una línea
  static double _perpendicularDistance(
    LatLng point,
    LatLng lineStart,
    LatLng lineEnd,
  ) {
    if (lineStart.latitude == lineEnd.latitude &&
        lineStart.longitude == lineEnd.longitude) {
      return _calculateDistance(point, lineStart);
    }

    final double A = point.latitude - lineStart.latitude;
    final double B = point.longitude - lineStart.longitude;
    final double C = lineEnd.latitude - lineStart.latitude;
    final double D = lineEnd.longitude - lineStart.longitude;

    final double dot = A * C + B * D;
    final double lenSq = C * C + D * D;
    double param = -1;

    if (lenSq != 0) param = dot / lenSq;

    double xx, yy;

    if (param < 0) {
      xx = lineStart.latitude;
      yy = lineStart.longitude;
    } else if (param > 1) {
      xx = lineEnd.latitude;
      yy = lineEnd.longitude;
    } else {
      xx = lineStart.latitude + param * C;
      yy = lineStart.longitude + param * D;
    }

    final double dx = point.latitude - xx;
    final double dy = point.longitude - yy;

    return sqrt(dx * dx + dy * dy) * 111000; // Convertir a metros aproximados
  }
}
