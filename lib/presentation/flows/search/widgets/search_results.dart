import 'package:flutter/material.dart';
import '../../../../models/models.dart';

class SearchResults extends StatelessWidget {
  final List<SearchResult> results;
  final Function(SearchResult) onResultSelected;
  final bool showLoadingIndicator;

  const SearchResults({
    super.key,
    required this.results,
    required this.onResultSelected,
    this.showLoadingIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty && !showLoadingIndicator) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 20,
      right: 20,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: showLoadingIndicator
              ? _buildLoadingIndicator()
              : _buildResultsList(),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onResultSelected(result),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (result.address.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            result.address,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9CA3AF),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
