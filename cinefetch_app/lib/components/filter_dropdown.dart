import 'package:cinefetch_app/animation/custom_animation.dart';
import 'package:flutter/material.dart';

class FilterDropdown extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Map<String, String>) onApply;
  final Map<String, String> initialFilters;

  const FilterDropdown({
    super.key,
    required this.onClose,
    required this.onApply,
    required this.initialFilters,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedQuality = 'All';
  String _selectedGenre = 'All';
  String _selectedYear = 'All';
  double _rating = 0;
  bool _filterEnabled = false;

  final List<String> _qualities = ['All', '720p', '1080p', '4K'];
  final List<String> _genres = [
    'All',
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
  ];
  final List<String> _years = ['All', '2023', '2022', '2021', '2020'];

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.initialFilters['quality'] ?? 'All';
    _selectedGenre = widget.initialFilters['genre'] ?? 'All';
    _selectedYear = widget.initialFilters['year'] ?? 'All';
    _rating = double.tryParse(widget.initialFilters['rating'] ?? '0') ?? 0;
    _filterEnabled = widget.initialFilters.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    const dropdownWidth = 120.0;

    return CustomAnimation(
      0.6,
      type: AnimationType.fastFade,
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1C32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with filter toggle and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter toggle checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _filterEnabled,
                      onChanged: (value) {
                        setState(() {
                          _filterEnabled = value ?? false;
                          if (!_filterEnabled) {
                            _selectedQuality = 'All';
                            _selectedGenre = 'All';
                            _selectedYear = 'All';
                            _rating = 0;
                            widget.onApply({});
                            widget.onClose();
                          }
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                      checkColor: Colors.white,
                    ),
                    const Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose,
                ),
              ],
            ),

            if (_filterEnabled) ...[
              const SizedBox(height: 16),

              // Quality Dropdown
              CustomAnimation(
                0.5,
                type: AnimationType.swing,
                _buildFilterRow(
                  title: 'Quality:',
                  value: _selectedQuality,
                  options: _qualities,
                  dropdownWidth: dropdownWidth,
                  onChanged: (value) =>
                      setState(() => _selectedQuality = value!),
                ),
              ),

              // Genre Dropdown
              CustomAnimation(
                0.6,
                type: AnimationType.swing,
                _buildFilterRow(
                  title: 'Genre:',
                  value: _selectedGenre,
                  options: _genres,
                  dropdownWidth: dropdownWidth,
                  onChanged: (value) => setState(() => _selectedGenre = value!),
                ),
              ),

              // Year Dropdown
              CustomAnimation(
                0.6,
                type: AnimationType.swing,
                _buildFilterRow(
                  title: 'Year:',
                  value: _selectedYear,
                  options: _years,
                  dropdownWidth: dropdownWidth,
                  onChanged: (value) => setState(() => _selectedYear = value!),
                ),
              ),

              // Rating Slider
              const SizedBox(height: 16),
              const Text(
                'Rating',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                      activeColor: Colors.lightBlueAccent,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      _rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),

              // Apply Button
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply({
                      'quality': _selectedQuality,
                      'genre': _selectedGenre,
                      'year': _selectedYear,
                      'rating': _rating.toStringAsFixed(1),
                    });
                    widget.onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Apply Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow({
    required String title,
    required String value,
    required List<String> options,
    required double dropdownWidth,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: dropdownWidth,
            child: DropdownButtonFormField<String>(
              value: value,
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1A2C50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              dropdownColor: const Color(0xFF1A2C50),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
