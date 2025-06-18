import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the visible page range (always 3 pages centered on current)
    int startPage = currentPage - 1;
    int endPage = currentPage + 1;

    // Adjust if near start or end
    if (startPage < 1) {
      startPage = 1;
      endPage = 3;
    }

    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = totalPages > 2 ? totalPages - 2 : 1;
    }

    // Ensure we don't exceed page limits
    startPage = startPage.clamp(1, totalPages);
    endPage = endPage.clamp(1, totalPages);

    return CustomAnimation(
      0.56,
      type: AnimationType.bounce,
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 22, 38, 65),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous Button
            CustomAnimation(
              0.58,
              type: AnimationType.swing,
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
              ),
            ),

            // Always show first page if not in range
            if (startPage > 1) ...[
              _buildPageButton(1),
              if (startPage > 2)
                const Text('...', style: TextStyle(color: Colors.white)),
            ],

            // Visible page range
            for (int i = startPage; i <= endPage; i++) _buildPageButton(i),

            // Show last page if not in range
            if (endPage < totalPages) ...[
              if (endPage < totalPages - 1)
                const Text('...', style: TextStyle(color: Colors.white)),
              _buildPageButton(totalPages),
            ],

            // Next Button
            CustomAnimation(
              0.58,
              type: AnimationType.swing,
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageButton(int pageNumber) {
    final isCurrent = pageNumber == currentPage;
    return CustomAnimation(
      0.6,
      type: AnimationType.bounce,
      GestureDetector(
        onTap: () => onPageChanged(pageNumber),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCurrent ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isCurrent
                ? null
                : Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '$pageNumber',
              style: TextStyle(
                color: isCurrent ? Colors.white : Colors.white.withOpacity(0.8),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
