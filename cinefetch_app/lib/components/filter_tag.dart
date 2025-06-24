import 'package:flutter/material.dart';

class FilterTag extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasActiveFilters;
  
  const FilterTag({
    super.key,
    required this.onPressed,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasActiveFilters 
              ? Colors.blue.withOpacity(0.2)
              : const Color(0xFF1A2C50),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasActiveFilters ? Colors.blue : Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              'Filters',
              style: TextStyle(
                color: hasActiveFilters ? Colors.blue : Colors.white,
              ),
            ),
            if (hasActiveFilters) const SizedBox(width: 6),
            if (hasActiveFilters) const Icon(Icons.check, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}