import '../../../../models/models.dart';

class SearchState {
  final String query;
  final bool isSearching;
  final List<SearchResult> results;
  final SearchResult? selectedResult;
  final List<String> searchHistory;
  final List<SearchResult> recentSearches;
  final List<SearchResult> favorites;
  final SearchFilters filters;
  final String? errorMessage;
  final bool hasSearched;

  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.results = const [],
    this.selectedResult,
    this.searchHistory = const [],
    this.recentSearches = const [],
    this.favorites = const [],
    this.filters = const SearchFilters(),
    this.errorMessage,
    this.hasSearched = false,
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    List<SearchResult>? results,
    SearchResult? selectedResult,
    List<String>? searchHistory,
    List<SearchResult>? recentSearches,
    List<SearchResult>? favorites,
    SearchFilters? filters,
    String? errorMessage,
    bool? hasSearched,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      selectedResult: selectedResult ?? this.selectedResult,
      searchHistory: searchHistory ?? this.searchHistory,
      recentSearches: recentSearches ?? this.recentSearches,
      favorites: favorites ?? this.favorites,
      filters: filters ?? this.filters,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchState &&
        other.query == query &&
        other.isSearching == isSearching &&
        other.results.length == results.length &&
        other.selectedResult == selectedResult &&
        other.searchHistory.length == searchHistory.length &&
        other.recentSearches.length == recentSearches.length &&
        other.favorites.length == favorites.length &&
        other.filters == filters &&
        other.errorMessage == errorMessage &&
        other.hasSearched == hasSearched;
  }

  @override
  int get hashCode =>
      query.hashCode ^
      isSearching.hashCode ^
      results.length.hashCode ^
      selectedResult.hashCode ^
      searchHistory.length.hashCode ^
      recentSearches.length.hashCode ^
      favorites.length.hashCode ^
      filters.hashCode ^
      errorMessage.hashCode ^
      hasSearched.hashCode;

  @override
  String toString() =>
      'SearchState(query: $query, isSearching: $isSearching, results: ${results.length}, hasSearched: $hasSearched)';
}

class SearchFilters {
  final double? radius;
  final List<String> types;
  final double? minRating;
  final bool? isOpenNow;
  final String? priceLevel;
  final bool sortByDistance;

  const SearchFilters({
    this.radius,
    this.types = const [],
    this.minRating,
    this.isOpenNow,
    this.priceLevel,
    this.sortByDistance = false,
  });

  SearchFilters copyWith({
    double? radius,
    List<String>? types,
    double? minRating,
    bool? isOpenNow,
    String? priceLevel,
    bool? sortByDistance,
  }) {
    return SearchFilters(
      radius: radius ?? this.radius,
      types: types ?? this.types,
      minRating: minRating ?? this.minRating,
      isOpenNow: isOpenNow ?? this.isOpenNow,
      priceLevel: priceLevel ?? this.priceLevel,
      sortByDistance: sortByDistance ?? this.sortByDistance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchFilters &&
        other.radius == radius &&
        other.types.length == types.length &&
        other.minRating == minRating &&
        other.isOpenNow == isOpenNow &&
        other.priceLevel == priceLevel &&
        other.sortByDistance == sortByDistance;
  }

  @override
  int get hashCode =>
      radius.hashCode ^
      types.length.hashCode ^
      minRating.hashCode ^
      isOpenNow.hashCode ^
      priceLevel.hashCode ^
      sortByDistance.hashCode;

  @override
  String toString() =>
      'SearchFilters(radius: $radius, types: $types, minRating: $minRating, isOpenNow: $isOpenNow, priceLevel: $priceLevel, sortByDistance: $sortByDistance)';
}
