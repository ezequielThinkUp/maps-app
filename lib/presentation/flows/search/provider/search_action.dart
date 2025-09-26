import '../../../../models/models.dart';
import 'search_state.dart';

abstract class SearchAction {}

class StartSearchAction extends SearchAction {
  final String query;
  StartSearchAction(this.query);
}

class ClearSearchAction extends SearchAction {}

class SelectResultAction extends SearchAction {
  final SearchResult result;
  SelectResultAction(this.result);
}

class AddToFavoritesAction extends SearchAction {
  final SearchResult result;
  AddToFavoritesAction(this.result);
}

class RemoveFromFavoritesAction extends SearchAction {
  final SearchResult result;
  RemoveFromFavoritesAction(this.result);
}

class UpdateFiltersAction extends SearchAction {
  final SearchFilters filters;
  UpdateFiltersAction(this.filters);
}
