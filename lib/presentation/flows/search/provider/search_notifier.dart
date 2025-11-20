import '../../../../services/places_service.dart';
import '../../../../models/models.dart';
import '../../../base/base_state_notifier.dart';
import 'search_action.dart';
import 'search_state.dart';

class SearchNotifier extends BaseStateNotifier<SearchState, SearchAction> {
  final PlacesService _placesService;

  SearchNotifier({required super.ref, PlacesService? placesService})
    : _placesService = placesService ?? PlacesService(),
      super(state: const SearchState());

  @override
  void reducer({required SearchAction action}) {
    switch (action) {
      case StartSearchAction(:final query):
        _startSearch(query);
        break;
      case ClearSearchAction():
        _clearSearch();
        break;
      case SelectResultAction(:final result):
        _selectResult(result);
        break;
      case AddToFavoritesAction(:final result):
        _addToFavorites(result);
        break;
      case RemoveFromFavoritesAction(:final result):
        _removeFromFavorites(result);
        break;
      case UpdateFiltersAction(:final filters):
        _updateFilters(filters);
        break;
    }
  }

  Future<void> _startSearch(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        query: '',
        isSearching: false,
        results: [],
        hasSearched: false,
      );
      return;
    }

    state = state.copyWith(query: query, isSearching: true, errorMessage: null);

    try {
      final results = await _placesService.searchPlaces(query);

      state = state.copyWith(
        isSearching: false,
        results: results,
        hasSearched: true,
        searchHistory: [
          query,
          ...state.searchHistory.where((h) => h != query).take(9),
        ],
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        errorMessage: 'Error al buscar lugares',
        hasSearched: true,
      );
    }
  }

  void _clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
      results: [],
      selectedResult: null,
      hasSearched: false,
      errorMessage: null,
    );
  }

  void _selectResult(SearchResult result) {
    state = state.copyWith(
      selectedResult: result,
      recentSearches: [
        result,
        ...state.recentSearches
            .where((r) => r.placeId != result.placeId)
            .take(9),
      ],
    );
  }

  void _addToFavorites(SearchResult result) {
    if (!state.favorites.any((f) => f.placeId == result.placeId)) {
      state = state.copyWith(favorites: [...state.favorites, result]);
    }
  }

  void _removeFromFavorites(SearchResult result) {
    state = state.copyWith(
      favorites: state.favorites
          .where((f) => f.placeId != result.placeId)
          .toList(),
    );
  }

  void _updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
    if (state.query.isNotEmpty) {
      _startSearch(state.query);
    }
  }
}
