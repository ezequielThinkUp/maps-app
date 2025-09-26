import '../../../base/base_provider.dart';
import 'search_notifier.dart';
import 'search_state.dart';

final searchProvider = baseProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref: ref),
);
