import 'package:dio/dio.dart';
import '../models/directions_model.dart';
import 'traffic_interceptor.dart';

class TrafficService {
  final Dio _dio;
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  static const String _accessToken =
      'pk.eyJ1IjoiZXplcXVpZWx0aGlua3VwIiwiYSI6ImNtZWl5MXBqODA3d3EyanB1M2F1eTQxNjUifQ.Y6jQCksAFTYqC6UFdN4nFw';

  TrafficService({Dio? dio}) : _dio = dio ?? _createDioWithInterceptors();

  static Dio _createDioWithInterceptors() {
    final dio = Dio();

    // Agregar interceptores
    dio.interceptors.addAll([
      TrafficInterceptor(),
      TrafficCacheInterceptor(cacheDuration: const Duration(minutes: 10)),
      TrafficMetricsInterceptor(),
    ]);

    // Configurar timeouts
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    return dio;
  }

  /// Obtiene las direcciones de conducción entre dos puntos
  ///
  /// [origin] - Coordenadas de origen (longitud,latitud)
  /// [destination] - Coordenadas de destino (longitud,latitud)
  /// [profile] - Tipo de perfil (driving, walking, cycling)
  Future<DirectionsModel> getDirections({
    required String origin,
    required String destination,
    String profile = 'driving',
    bool alternatives = true,
    String geometries = 'polyline6',
    String overview = 'simplified',
    bool steps = false,
  }) async {
    try {
      final coordinates = '$origin;$destination';
      final url = '$_baseUrl/$profile/$coordinates';

      final response = await _dio.get(
        url,
        queryParameters: {
          'alternatives': alternatives,
          'geometries': geometries,
          'overview': overview,
          'steps': steps,
          'access_token': _accessToken,
        },
      );

      if (response.statusCode == 200) {
        return DirectionsModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener direcciones: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Obtiene las direcciones usando objetos LatLng
  Future<DirectionsModel> getDirectionsFromLatLng({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String profile = 'driving',
    bool alternatives = true,
    String geometries = 'polyline6',
    String overview = 'simplified',
    bool steps = false,
  }) async {
    final origin = '$originLng,$originLat';
    final destination = '$destLng,$destLat';

    return getDirections(
      origin: origin,
      destination: destination,
      profile: profile,
      alternatives: alternatives,
      geometries: geometries,
      overview: overview,
      steps: steps,
    );
  }

  /// Obtiene las direcciones optimizadas para tráfico
  Future<DirectionsModel> getTrafficOptimizedDirections({
    required String origin,
    required String destination,
    bool alternatives = true,
    String geometries = 'polyline6',
    String overview = 'full',
    bool steps = true,
  }) async {
    return getDirections(
      origin: origin,
      destination: destination,
      profile: 'driving-traffic',
      alternatives: alternatives,
      geometries: geometries,
      overview: overview,
      steps: steps,
    );
  }

  /// Obtiene métricas de rendimiento del servicio
  Map<String, dynamic> getMetrics() {
    final metricsInterceptor = _dio.interceptors
        .whereType<TrafficMetricsInterceptor>()
        .firstOrNull;

    return metricsInterceptor?.getMetrics() ?? {};
  }

  /// Obtiene estadísticas del cache
  Map<String, dynamic> getCacheStats() {
    final cacheInterceptor = _dio.interceptors
        .whereType<TrafficCacheInterceptor>()
        .firstOrNull;

    return cacheInterceptor?.getCacheStats() ?? {};
  }

  /// Limpia el cache
  void clearCache() {
    final cacheInterceptor = _dio.interceptors
        .whereType<TrafficCacheInterceptor>()
        .firstOrNull;

    cacheInterceptor?.clearCache();
  }

  /// Limpia las métricas
  void clearMetrics() {
    final metricsInterceptor = _dio.interceptors
        .whereType<TrafficMetricsInterceptor>()
        .firstOrNull;

    metricsInterceptor?.clearMetrics();
  }
}
