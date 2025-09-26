import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'search_bar.dart';

class RouteSearchBars extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onFromSearch;
  final VoidCallback onToSearch;
  final VoidCallback onFromClear;
  final VoidCallback onToClear;
  final VoidCallback? onManualLocationSelect;
  final bool isFromSearching;
  final bool isToSearching;
  final bool showManualOption;

  const RouteSearchBars({
    super.key,
    required this.fromController,
    required this.toController,
    required this.onFromSearch,
    required this.onToSearch,
    required this.onFromClear,
    required this.onToClear,
    this.onManualLocationSelect,
    this.isFromSearching = false,
    this.isToSearching = false,
    this.showManualOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // From Search Bar
          MapSearchBar(
            controller: fromController,
            onSearch: onFromSearch,
            onClear: onFromClear,
            onManualLocationSelect: onManualLocationSelect,
            isSearching: isFromSearching,
            showManualOption: showManualOption,
            placeholder: 'maps.search_from'.tr(),
            accentColor: const Color(0xFF10B981), // Green color for origin
          ),

          const SizedBox(height: 10),

          // To Search Bar
          MapSearchBar(
            controller: toController,
            onSearch: onToSearch,
            onClear: onToClear,
            onManualLocationSelect: onManualLocationSelect,
            isSearching: isToSearching,
            showManualOption: showManualOption,
            placeholder: 'maps.search_to'.tr(),
            accentColor: const Color(0xFFEF4444), // Red color for destination
          ),
        ],
      ),
    );
  }
}
