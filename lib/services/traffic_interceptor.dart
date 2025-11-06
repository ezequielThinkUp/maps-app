import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 [TRAFFIC] REQUEST: ${options.method} ${options.uri}');
    print('🌐 [TRAFFIC] Headers: ${options.headers}');
    print('🌐 [TRAFFIC] Query Parameters: ${options.queryParameters}');

    // Agregar headers personalizados si es necesario
    options.headers['User-Agent'] = 'MapsApp/1.0';
    options.headers['Accept'] = 'application/json';

    // Agregar timestamp para tracking
    options.extra['request_time'] = DateTime.now();

    // Agregar query parameters estándar de Mapbox si no están presentes
    final defaultParams = {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
    };

    // Combinar parámetros existentes con los por defecto
    options.queryParameters.addAll(defaultParams);

    // Asegurar que el access_token esté presente
    if (!options.queryParameters.containsKey('access_token')) {
      options.queryParameters['access_token'] =
          'pk.eyJ1IjoiZXplcXVpZWx0aGlua3VwIiwiYSI6ImNtZWl5MXBqODA3d3EyanB1M2F1eTQxNjUifQ.Y6jQCksAFTYqC6UFdN4nFw';
    }

    print('🌐 [TRAFFIC] Final Query Parameters: ${options.queryParameters}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestTime =
        response.requestOptions.extra['request_time'] as DateTime?;
    final responseTime = DateTime.now();
    final duration = requestTime != null
        ? responseTime.difference(requestTime).inMilliseconds
        : 0;

    print(
      '✅ [TRAFFIC] RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    print('✅ [TRAFFIC] Duration: ${duration}ms');
    print(
      '✅ [TRAFFIC] Data size: ${response.data.toString().length} characters',
    );

    // Log de respuesta exitosa para debugging
    if (response.statusCode == 200) {
      print('✅ [TRAFFIC] Success response received');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestTime = err.requestOptions.extra['request_time'] as DateTime?;
    final errorTime = DateTime.now();
    final duration = requestTime != null
        ? errorTime.difference(requestTime).inMilliseconds
        : 0;

    print('❌ [TRAFFIC] ERROR: ${err.type}');
    print('❌ [TRAFFIC] URL: ${err.requestOptions.uri}');
    print('❌ [TRAFFIC] Duration: ${duration}ms');
    print('❌ [TRAFFIC] Message: ${err.message}');

    // Manejo específico por tipo de error
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        print('❌ [TRAFFIC] Connection timeout - check internet connection');
        break;
      case DioExceptionType.sendTimeout:
        print('❌ [TRAFFIC] Send timeout - server not responding');
        break;
      case DioExceptionType.receiveTimeout:
        print('❌ [TRAFFIC] Receive timeout - server response too slow');
        break;
      case DioExceptionType.badResponse:
        print('❌ [TRAFFIC] Bad response: ${err.response?.statusCode}');
        print('❌ [TRAFFIC] Response data: ${err.response?.data}');
        break;
      case DioExceptionType.cancel:
        print('❌ [TRAFFIC] Request cancelled');
        break;
      case DioExceptionType.connectionError:
        print('❌ [TRAFFIC] Connection error - no internet');
        break;
      case DioExceptionType.badCertificate:
        print('❌ [TRAFFIC] Bad certificate - SSL issue');
        break;
      case DioExceptionType.unknown:
        print('❌ [TRAFFIC] Unknown error occurred');
        break;
    }

    // Intentar retry para errores de red
    if (_shouldRetry(err)) {
      print('🔄 [TRAFFIC] Attempting retry...');
      _retryRequest(err, handler);
      return;
    }

    handler.next(err);
  }

  /// Determina si se debe intentar retry basado en el tipo de error
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  /// Implementa retry automático para errores de red
  void _retryRequest(DioException err, ErrorInterceptorHandler handler) {
    final retryCount = (err.requestOptions.extra['retry_count'] ?? 0) as int;
    final maxRetries = 3;

    if (retryCount < maxRetries) {
      print('🔄 [TRAFFIC] Retry attempt ${retryCount + 1}/$maxRetries');

      // Agregar delay exponencial
      final delay = Duration(milliseconds: 1000 * (retryCount + 1));

      Future.delayed(delay, () {
        final options = err.requestOptions;
        options.extra['retry_count'] = retryCount + 1;

        // Crear nueva instancia de Dio para el retry
        final dio = Dio();
        dio.interceptors.add(TrafficInterceptor());

        dio
            .request(
              options.path,
              data: options.data,
              queryParameters: options.queryParameters,
              options: Options(
                method: options.method,
                headers: options.headers,
                extra: options.extra,
              ),
            )
            .then((response) {
              handler.resolve(response);
            })
            .catchError((error) {
              if (error is DioException) {
                handler.next(error);
              } else {
                handler.next(
                  DioException(
                    requestOptions: options,
                    error: error,
                    type: DioExceptionType.unknown,
                  ),
                );
              }
            });
      });
    } else {
      print('❌ [TRAFFIC] Max retries reached, giving up');
      handler.next(err);
    }
  }
}

/// Interceptor para cache de respuestas
class TrafficCacheInterceptor extends Interceptor {
  final Map<String, dynamic> _cache = {};
  final Duration _cacheDuration;

  TrafficCacheInterceptor({Duration? cacheDuration})
    : _cacheDuration = cacheDuration ?? const Duration(minutes: 5);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cacheKey = _generateCacheKey(options);
    final cachedResponse = _cache[cacheKey];

    if (cachedResponse != null) {
      final cacheTime = cachedResponse['timestamp'] as DateTime;
      final isExpired = DateTime.now().difference(cacheTime) > _cacheDuration;

      if (!isExpired) {
        print('💾 [CACHE] Returning cached response for: ${options.uri}');
        handler.resolve(
          Response(
            data: cachedResponse['data'],
            statusCode: 200,
            requestOptions: options,
          ),
        );
        return;
      } else {
        print('💾 [CACHE] Cache expired, removing: ${options.uri}');
        _cache.remove(cacheKey);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cache[cacheKey] = {'data': response.data, 'timestamp': DateTime.now()};
      print('💾 [CACHE] Cached response for: ${response.requestOptions.uri}');
    }

    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.method}_${options.uri}_${options.queryParameters.hashCode}';
  }

  /// Limpia el cache
  void clearCache() {
    _cache.clear();
    print('💾 [CACHE] Cache cleared');
  }

  /// Obtiene estadísticas del cache
  Map<String, dynamic> getCacheStats() {
    return {'size': _cache.length, 'keys': _cache.keys.toList()};
  }
}

/// Interceptor para métricas y analytics
class TrafficMetricsInterceptor extends Interceptor {
  final List<Map<String, dynamic>> _metrics = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final metric = {
      'url': options.uri.toString(),
      'method': options.method,
      'start_time': DateTime.now(),
      'status': 'pending',
    };

    options.extra['metric_id'] = _metrics.length;
    _metrics.add(metric);

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final metricId = response.requestOptions.extra['metric_id'] as int?;
    if (metricId != null && metricId < _metrics.length) {
      final metric = _metrics[metricId];
      final startTime = metric['start_time'] as DateTime;
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      metric['end_time'] = DateTime.now();
      metric['duration'] = duration;
      metric['status'] = 'success';
      metric['status_code'] = response.statusCode;

      print('📊 [METRICS] Request completed in ${duration}ms');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final metricId = err.requestOptions.extra['metric_id'] as int?;
    if (metricId != null && metricId < _metrics.length) {
      final metric = _metrics[metricId];
      final startTime = metric['start_time'] as DateTime;
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      metric['end_time'] = DateTime.now();
      metric['duration'] = duration;
      metric['status'] = 'error';
      metric['error_type'] = err.type.toString();
      metric['error_message'] = err.message;

      print('📊 [METRICS] Request failed after ${duration}ms');
    }

    handler.next(err);
  }

  /// Obtiene métricas de rendimiento
  Map<String, dynamic> getMetrics() {
    if (_metrics.isEmpty) return {};

    final successful = _metrics.where((m) => m['status'] == 'success').length;
    final failed = _metrics.where((m) => m['status'] == 'error').length;
    final total = _metrics.length;

    final durations = _metrics
        .where((m) => m['duration'] != null)
        .map((m) => m['duration'] as int)
        .toList();

    final avgDuration = durations.isNotEmpty
        ? durations.reduce((a, b) => a + b) / durations.length
        : 0;

    return {
      'total_requests': total,
      'successful_requests': successful,
      'failed_requests': failed,
      'success_rate': total > 0
          ? '${(successful / total * 100).toStringAsFixed(2)}%'
          : '0%',
      'average_duration_ms': avgDuration.toStringAsFixed(2),
      'recent_requests': _metrics.take(10).toList(),
    };
  }

  /// Limpia las métricas
  void clearMetrics() {
    _metrics.clear();
    print('📊 [METRICS] Metrics cleared');
  }
}
