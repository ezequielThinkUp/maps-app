import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ContentState { loading, content }

final contentStateNotifierProvider = StateProvider<ContentState>(
  (ref) => ContentState.content,
);
