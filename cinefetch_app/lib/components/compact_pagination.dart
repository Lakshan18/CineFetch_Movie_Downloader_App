import 'package:flutter/material.dart';

class CompactPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const CompactPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A35),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous Button
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            onPressed: currentPage > 1 ? onPrev : null,
            splashRadius: 20,
          ),
          
          // Current Page
          Text(
            '$currentPage',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Dot Separator
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Next Page
          Text(
            '${currentPage + 1}',
            style: TextStyle(
              color: Colors.white.withOpacity(currentPage < totalPages ? 0.8 : 0.4),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Ellipsis
          if (totalPages - currentPage > 2)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Last Page
          if (totalPages - currentPage > 1)
            Text(
              '$totalPages',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          
          // Next Button
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
            onPressed: currentPage < totalPages ? onNext : null,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}