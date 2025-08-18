import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import '../../../../models/models.dart';
import 'search_action.dart';
import 'search_state.dart';

class SearchNotifier extends BaseStateNotifier<SearchState, SearchAction> {
  SearchNotifier(Ref ref) : super(state: const SearchState(), ref: ref);

  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  static const int _maxHistoryItems = 10;
  static const int _maxRecentItems = 5;

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
      case AddToHistoryAction(:final query):
        _addToHistory(query);
        break;
      case RemoveFromHistoryAction(:final query):
        _removeFromHistory(query);
        break;
      case ClearHistoryAction():
        _clearHistory();
        break;
      case AddToRecentSearchesAction(:final result):
        _addToRecentSearches(result);
        break;
      case RemoveFromRecentSearchesAction(:final result):
        _removeFromRecentSearches(result);
        break;
      case ClearRecentSearchesAction():
        _clearRecentSearches();
        break;
      case AddToFavoritesAction(:final result):
        _addToFavorites(result);
        break;
      case RemoveFromFavoritesAction(:final result):
        _removeFromFavorites(result);
        break;
      case ClearFavoritesAction():
        _clearFavorites();
        break;
      case UpdateFiltersAction(:final filters):
        _updateFilters(filters);
        break;
      case ResetFiltersAction():
        _resetFilters();
        break;
      case SetErrorMessageAction(:final errorMessage):
        _setErrorMessage(errorMessage);
        break;
      case ClearErrorMessageAction():
        _clearErrorMessage();
        break;
    }
  }

  void _updateQuery(String query) {
    // Cancelar el timer anterior si existe
    _debounceTimer?.cancel();

    state = state.copyWith(query: query, errorMessage: null);

    // Si la query está vacía, limpiar resultados
    if (query.isEmpty) {
      state = state.copyWith(results: [], hasSearched: false);
      return;
    }

    // Configurar debouncing
    _debounceTimer = Timer(_debounceDelay, () {
      if (query.isNotEmpty) {
        _startSearch(query);
      }
    });
  }

  void _startSearch(String query) async {
    state = state.copyWith(
      query: query,
      isSearching: true,
      results: [],
      errorMessage: null,
      hasSearched: true,
    );

    try {
      // Agregar a historial
      _addToHistory(query);

      // Realizar búsqueda
      final results = await _performSearch(query);

      // Aplicar filtros si existen
      final filteredResults = _applyFilters(results);

      reducer(action: SearchSuccessAction(filteredResults));
    } catch (e) {
      reducer(action: SearchErrorAction(e.toString()));
    }
  }

  Future<List<SearchResult>> _performSearch(String query) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulación de búsqueda con más datos
    if (query.toLowerCase().contains('restaurant') ||
        query.toLowerCase().contains('restaurante')) {
      return [
        const SearchResult(
          name: 'Restaurante El Buen Sabor',
          address: 'Calle Principal 123, Ciudad',
          location: LatLng(40.4168, -3.7038),
          placeId: 'rest_1',
          rating: 4.5,
          userRatingsTotal: 150,
          types: 'restaurant,food,establishment',
          isOpenNow: true,
          priceLevel: 'moderate',
          vicinity: 'Centro Historico',
        ),
        const SearchResult(
          name: 'Cafe Central',
          address: 'Plaza Mayor 45, Ciudad',
          location: LatLng(40.4155, -3.7074),
          placeId: 'cafe_1',
          rating: 4.2,
          userRatingsTotal: 89,
          types: 'cafe,food,establishment',
          isOpenNow: true,
          priceLevel: 'low',
          vicinity: 'Plaza Mayor',
        ),
        const SearchResult(
          name: 'Pizzeria Italiana',
          address: 'Avenida de la Paz 67, Ciudad',
          location: LatLng(40.4175, -3.7050),
          placeId: 'pizza_1',
          rating: 4.7,
          userRatingsTotal: 234,
          types: 'restaurant,food,establishment',
          isOpenNow: false,
          priceLevel: 'high',
          vicinity: 'Zona Norte',
        ),
      ];
    } else if (query.toLowerCase().contains('park') ||
        query.toLowerCase().contains('parque')) {
      return [
        const SearchResult(
          name: 'Parque del Retiro',
          address: 'Plaza de la Independencia, Madrid',
          location: LatLng(40.4168, -3.6886),
          placeId: 'park_1',
          rating: 4.8,
          userRatingsTotal: 567,
          types: 'park,tourist_attraction,establishment',
          isOpenNow: true,
          vicinity: 'Centro',
        ),
        const SearchResult(
          name: 'Parque de la Ciudad',
          address: 'Calle de los Jardines 12, Ciudad',
          location: LatLng(40.4180, -3.6900),
          placeId: 'park_2',
          rating: 4.3,
          userRatingsTotal: 123,
          types: 'park,establishment',
          isOpenNow: true,
          vicinity: 'Zona Este',
        ),
      ];
    } else if (query.toLowerCase().contains('hotel') ||
        query.toLowerCase().contains('alojamiento')) {
      return [
        const SearchResult(
          name: 'Hotel Gran Plaza',
          address: 'Calle del Comercio 89, Ciudad',
          location: LatLng(40.4190, -3.7000),
          placeId: 'hotel_1',
          rating: 4.6,
          userRatingsTotal: 445,
          types: 'lodging,establishment',
          isOpenNow: true,
          priceLevel: 'very_high',
          vicinity: 'Centro Comercial',
        ),
      ];
    } else {
      // Búsqueda genérica
      return [
        SearchResult(
          name: 'Resultado para: $query',
          address: 'Dirección de ejemplo',
          location: const LatLng(40.4168, -3.7038),
          placeId: 'generic_1',
          rating: 4.0,
          userRatingsTotal: 50,
          types: 'establishment',
          isOpenNow: true,
          vicinity: 'Ciudad',
        ),
      ];
    }
  }

  List<SearchResult> _applyFilters(List<SearchResult> results) {
    var filteredResults = List<SearchResult>.from(results);

    // Filtrar por rating mínimo
    if (state.filters.minRating != null) {
      filteredResults = filteredResults
          .where(
            (result) =>
                result.rating != null &&
                result.rating! >= state.filters.minRating!,
          )
          .toList();
    }

    // Filtrar por tipo
    if (state.filters.types.isNotEmpty) {
      filteredResults = filteredResults
          .where(
            (result) =>
                result.types != null &&
                state.filters.types.any((type) => result.types!.contains(type)),
          )
          .toList();
    }

    // Filtrar por nivel de precio
    if (state.filters.priceLevel != null) {
      filteredResults = filteredResults
          .where((result) => result.priceLevel == state.filters.priceLevel)
          .toList();
    }

    // Filtrar por estado abierto/cerrado
    if (state.filters.isOpenNow != null) {
      filteredResults = filteredResults
          .where((result) => result.isOpenNow == state.filters.isOpenNow)
          .toList();
    }

    // Ordenar por distancia si está habilitado
    if (state.filters.sortByDistance) {
      // Aquí se implementaría la lógica de ordenamiento por distancia
      // Por ahora solo invertimos la lista como ejemplo
      filteredResults = filteredResults.reversed.toList();
    }

    return filteredResults;
  }

  void _searchSuccess(List<SearchResult> results) {
    state = state.copyWith(
      isSearching: false,
      results: results,
      errorMessage: null,
    );
  }

  void _searchError(String error) {
    state = state.copyWith(
      isSearching: false,
      results: [],
      errorMessage: error,
    );
  }

  void _selectResult(SearchResult result) {
    state = state.copyWith(selectedResult: result);
    _addToRecentSearches(result);
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    state = state.copyWith(
      query: '',
      results: [],
      selectedResult: null,
      errorMessage: null,
      hasSearched: false,
    );
  }

  void _clearResults() {
    state = state.copyWith(results: [], selectedResult: null);
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;

    final newHistory = List<String>.from(state.searchHistory);

    // Remover si ya existe
    newHistory.remove(query);

    // Agregar al inicio
    newHistory.insert(0, query);

    // Limitar el tamaño
    if (newHistory.length > _maxHistoryItems) {
      newHistory.removeRange(_maxHistoryItems, newHistory.length);
    }

    state = state.copyWith(searchHistory: newHistory);
  }

  void _removeFromHistory(String query) {
    final newHistory = List<String>.from(state.searchHistory);
    newHistory.remove(query);
    state = state.copyWith(searchHistory: newHistory);
  }

  void _clearHistory() {
    state = state.copyWith(searchHistory: []);
  }

  void _addToRecentSearches(SearchResult result) {
    final newRecentSearches = List<SearchResult>.from(state.recentSearches);

    // Remover si ya existe
    newRecentSearches.removeWhere((item) => item.placeId == result.placeId);

    // Agregar al inicio
    newRecentSearches.insert(0, result);

    // Limitar el tamaño
    if (newRecentSearches.length > _maxRecentItems) {
      newRecentSearches.removeRange(_maxRecentItems, newRecentSearches.length);
    }

    state = state.copyWith(recentSearches: newRecentSearches);
  }

  void _removeFromRecentSearches(SearchResult result) {
    final newRecentSearches = List<SearchResult>.from(state.recentSearches);
    newRecentSearches.removeWhere((item) => item.placeId == result.placeId);
    state = state.copyWith(recentSearches: newRecentSearches);
  }

  void _clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }

  void _addToFavorites(SearchResult result) {
    final newFavorites = List<SearchResult>.from(state.favorites);

    // Verificar si ya existe
    final exists = newFavorites.any((item) => item.placeId == result.placeId);
    if (!exists) {
      newFavorites.add(result);
      state = state.copyWith(favorites: newFavorites);
    }
  }

  void _removeFromFavorites(SearchResult result) {
    final newFavorites = List<SearchResult>.from(state.favorites);
    newFavorites.removeWhere((item) => item.placeId == result.placeId);
    state = state.copyWith(favorites: newFavorites);
  }

  void _clearFavorites() {
    state = state.copyWith(favorites: []);
  }

  void _updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);

    // Re-aplicar búsqueda si hay resultados
    if (state.hasSearched && state.query.isNotEmpty) {
      _startSearch(state.query);
    }
  }

  void _resetFilters() {
    state = state.copyWith(filters: const SearchFilters());

    // Re-aplicar búsqueda si hay resultados
    if (state.hasSearched && state.query.isNotEmpty) {
      _startSearch(state.query);
    }
  }

  void _setErrorMessage(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  void _clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }

  // Métodos públicos para facilitar el uso
  void search(String query) {
    _debounceTimer?.cancel();
    _startSearch(query);
  }

  void toggleFavorite(SearchResult result) {
    final isFavorite = state.favorites.any(
      (item) => item.placeId == result.placeId,
    );
    if (isFavorite) {
      reducer(action: RemoveFromFavoritesAction(result));
    } else {
      reducer(action: AddToFavoritesAction(result));
    }
  }

  bool isFavorite(SearchResult result) {
    return state.favorites.any((item) => item.placeId == result.placeId);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchProvider = baseProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref),
);
