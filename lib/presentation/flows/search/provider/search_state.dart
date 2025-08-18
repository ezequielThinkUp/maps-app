import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchState {
  final String query;
  final bool isSearching;
  final List<SearchResult> results;
  final SearchResult? selectedResult;

  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.results = const [],
    this.selectedResult,
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    List<SearchResult>? results,
    SearchResult? selectedResult,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      selectedResult: selectedResult ?? this.selectedResult,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchState &&
        other.query == query &&
        other.isSearching == isSearching &&
        other.results.length == results.length &&
        other.selectedResult == selectedResult;
  }

  @override
  int get hashCode =>
      query.hashCode ^
      isSearching.hashCode ^
      results.length.hashCode ^
      selectedResult.hashCode;

  @override
  String toString() =>
      'SearchState(query: $query, isSearching: $isSearching, results: ${results.length})';
}

class SearchResult {
  final String name;
  final String address;
  final LatLng location;
  final String? placeId;

  const SearchResult({
    required this.name,
    required this.address,
    required this.location,
    this.placeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult &&
        other.name == name &&
        other.address == address &&
        other.location == location;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ location.hashCode;

  @override
  String toString() =>
      'SearchResult(name: $name, address: $address, location: $location)';
}
