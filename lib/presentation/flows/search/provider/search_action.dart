import '../../../../models/models.dart';

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
