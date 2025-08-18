import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import '../../../../models/models.dart';
import 'search_action.dart';
import 'search_state.dart';

class SearchNotifier extends BaseStateNotifier<SearchState, SearchAction> {
  SearchNotifier(Ref ref) : super(state: const SearchState(), ref: ref);

  @override
  void reducer({required SearchAction action}) {
    switch (action) {
      case UpdateQueryAction(:final query):
        _updateQuery(query);
        break;
      case StartSearchAction(:final query):
        _startSearch(query);
        break;
      case SearchSuccessAction(:final results):
        _searchSuccess(results);
        break;
      case SearchErrorAction(:final error):
        _searchError(error);
        break;
      case SelectResultAction(:final result):
        _selectResult(result);
        break;
      case ClearSearchAction():
        _clearSearch();
        break;
      case ClearResultsAction():
        _clearResults();
        break;
    }
  }

  void _updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void _startSearch(String query) {
    state = state.copyWith(query: query, isSearching: true, results: []);

    // Simular búsqueda (en una implementación real, aquí se llamaría a la API de Google Places)
    _simulateSearch(query);
  }

  void _searchSuccess(List<SearchResult> results) {
    state = state.copyWith(isSearching: false, results: results);
  }

  void _searchError(String error) {
    state = state.copyWith(isSearching: false, results: []);
  }

  void _selectResult(SearchResult result) {
    state = state.copyWith(selectedResult: result);
  }

  void _clearSearch() {
    state = state.copyWith(query: '', results: [], selectedResult: null);
  }

  void _clearResults() {
    state = state.copyWith(results: [], selectedResult: null);
  }

  // Simulación de búsqueda para demostración
  void _simulateSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (query.toLowerCase().contains('restaurant') ||
        query.toLowerCase().contains('restaurante')) {
      final results = [
        const SearchResult(
          name: 'Restaurante El Buen Sabor',
          address: 'Calle Principal 123, Ciudad',
          location: LatLng(40.4168, -3.7038),
        ),
        const SearchResult(
          name: 'Café Central',
          address: 'Plaza Mayor 45, Ciudad',
          location: LatLng(40.4155, -3.7074),
        ),
      ];
      reducer(action: SearchSuccessAction(results));
    } else if (query.toLowerCase().contains('park') ||
        query.toLowerCase().contains('parque')) {
      final results = [
        const SearchResult(
          name: 'Parque del Retiro',
          address: 'Plaza de la Independencia, Madrid',
          location: LatLng(40.4168, -3.6886),
        ),
      ];
      reducer(action: SearchSuccessAction(results));
    } else {
      reducer(action: SearchErrorAction('No se encontraron resultados'));
    }
  }
}

final searchProvider = baseProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref),
);
