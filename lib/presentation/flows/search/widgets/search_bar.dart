import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
    this.accentColor = const Color(0xFF3B82F6),
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  bool _showManualOption = false;
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
    setState(() {
      _showManualOption = _focusNode.hasFocus && widget.showManualOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                onSubmitted: (_) => widget.onSearch(),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              IconButton(
                onPressed: widget.onClear,
                icon: const Icon(
                  Icons.clear,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
            if (widget.isSearching)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
