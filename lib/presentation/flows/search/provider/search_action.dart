import '../../../../models/models.dart';
import 'search_state.dart';

abstract class SearchAction {}

class UpdateQueryAction extends SearchAction {
  final String query;
  UpdateQueryAction(this.query);
}

class StartSearchAction extends SearchAction {
  final String query;
  StartSearchAction(this.query);
}

class SearchSuccessAction extends SearchAction {
  final List<SearchResult> results;
  SearchSuccessAction(this.results);
}

class SearchErrorAction extends SearchAction {
  final String error;
  SearchErrorAction(this.error);
}

class SelectResultAction extends SearchAction {
  final SearchResult result;
  SelectResultAction(this.result);
}

class ClearSearchAction extends SearchAction {}

class ClearResultsAction extends SearchAction {}

class AddToHistoryAction extends SearchAction {
  final String query;
  AddToHistoryAction(this.query);
}

class RemoveFromHistoryAction extends SearchAction {
  final String query;
  RemoveFromHistoryAction(this.query);
}

class ClearHistoryAction extends SearchAction {}

class AddToRecentSearchesAction extends SearchAction {
  final SearchResult result;
  AddToRecentSearchesAction(this.result);
}

class RemoveFromRecentSearchesAction extends SearchAction {
  final SearchResult result;
  RemoveFromRecentSearchesAction(this.result);
}

class ClearRecentSearchesAction extends SearchAction {}

class AddToFavoritesAction extends SearchAction {
  final SearchResult result;
  AddToFavoritesAction(this.result);
}

class RemoveFromFavoritesAction extends SearchAction {
  final SearchResult result;
  RemoveFromFavoritesAction(this.result);
}

class ClearFavoritesAction extends SearchAction {}

class UpdateFiltersAction extends SearchAction {
  final SearchFilters filters;
  UpdateFiltersAction(this.filters);
}

class ResetFiltersAction extends SearchAction {}

class SetErrorMessageAction extends SearchAction {
  final String? errorMessage;
  SetErrorMessageAction(this.errorMessage);
}

class ClearErrorMessageAction extends SearchAction {}
