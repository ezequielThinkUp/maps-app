import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/theme/color_schema.dart';

class MapSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final VoidCallback? onManualLocationSelect;
  final bool isSearching;
  final bool showManualOption;
  final String placeholder;
  final Color accentColor;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    this.onManualLocationSelect,
    this.isSearching = false,
    this.showManualOption = true,
    this.placeholder = 'maps.search_placeholder',
    this.accentColor = AppColorSchema.primary,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Focus change handler - can be extended for future features
    setState(() {
      // Manual option feature can be added here if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColorSchema.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColorSchema.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.search, color: widget.accentColor, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: widget.placeholder.tr(),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColorSchema.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColorSchema.onSurface,
                ),
                onSubmitted: (_) => widget.onSearch(),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              IconButton(
                onPressed: widget.onClear,
                icon: Icon(
                  Icons.clear,
                  color: AppColorSchema.onSurfaceVariant,
                  size: 20,
                ),
              ),
            if (widget.isSearching)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColorSchema.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
