// import 'package:flutter/material.dart';

// class PaginationControls extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function(int) onPageChanged;

//   const PaginationControls({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0A1A35),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Previous Button
//           IconButton(
//             icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
//             onPressed: currentPage > 1
//                 ? () => onPageChanged(currentPage - 1)
//                 : null,
//           ),
          
//           // Page Numbers
//           Row(
//             children: List.generate(totalPages, (index) {
//               final pageNumber = index + 1;
//               final isCurrent = currentPage == pageNumber;
              
//               // Show limited page numbers if there are many pages
//               if (totalPages > 5) {
//                 if ((pageNumber <= 3) || 
//                     (pageNumber >= totalPages - 2) || 
//                     (pageNumber >= currentPage - 1 && pageNumber <= currentPage + 1)) {
//                   return _buildPageNumber(pageNumber, isCurrent);
//                 }
//                 if (pageNumber == 4 && currentPage > 5) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4),
//                     child: Text('...', style: TextStyle(color: Colors.white)),
//                   );
//                 }
//                 if (pageNumber == totalPages - 3 && currentPage < totalPages - 4) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 4),
//                     child: Text('...', style: TextStyle(color: Colors.white)),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               } else {
//                 return _buildPageNumber(pageNumber, isCurrent);
//               }
//             }),
//           ),
          
//           // Next Button
//           IconButton(
//             icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
//             onPressed: currentPage < totalPages
//                 ? () => onPageChanged(currentPage + 1)
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPageNumber(int pageNumber, bool isCurrent) {
//     return GestureDetector(
//       onTap: () => onPageChanged(pageNumber),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           color: isCurrent ? Colors.blue : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             '$pageNumber',
//             style: TextStyle(
//               color: isCurrent ? Colors.white : Colors.white.withOpacity(0.7),
//               fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A35),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          
          // Always show first page if not in range
          if (startPage > 1) ...[
            _buildPageButton(1),
            if (startPage > 2) const Text('...', style: TextStyle(color: Colors.white)),
          ],
          
          // Visible page range
          for (int i = startPage; i <= endPage; i++)
            _buildPageButton(i),
          
          // Show last page if not in range
          if (endPage < totalPages) ...[
            if (endPage < totalPages - 1) const Text('...', style: TextStyle(color: Colors.white)),
            _buildPageButton(totalPages),
          ],
          
          // Next Button
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(int pageNumber) {
    final isCurrent = pageNumber == currentPage;
    return GestureDetector(
      onTap: () => onPageChanged(pageNumber),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCurrent 
              ? Colors.blue 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isCurrent 
              ? null 
              : Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            '$pageNumber',
            style: TextStyle(
              color: isCurrent 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.8),
              fontWeight: isCurrent 
                  ? FontWeight.bold 
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}