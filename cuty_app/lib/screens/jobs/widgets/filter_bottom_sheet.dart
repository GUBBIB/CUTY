import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/job_providers.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  final List<String> _allOptions = [
    '📍 내 주변',
    '💰 고수익',
    '🕒 단기',
    '✨ 초보가능',
    '📅 주말',
    '🍖 식사제공',
    '🚌 통근버스',
  ];

  late List<String> _tempSelectedFilters;

  @override
  void initState() {
    super.initState();
    // Initialize with current provider state
    _tempSelectedFilters = List.from(ref.read(jobFilterProvider));
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_tempSelectedFilters.contains(filter)) {
        _tempSelectedFilters.remove(filter);
      } else {
        _tempSelectedFilters.add(filter);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _tempSelectedFilters.clear();
    });
  }

  void _applyFilters() {
    ref.read(jobFilterProvider.notifier).state = List.from(_tempSelectedFilters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(jobThemeProvider);

    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '상세 필터 설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Dark Navy
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 20),
          
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _allOptions.map((option) {
                  final isSelected = _tempSelectedFilters.contains(option);
                  return GestureDetector(
                    onTap: () => _toggleFilter(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? theme.primaryColor : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? theme.primaryColor : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              // Reset Button
              Expanded(
                flex: 3,
                child: TextButton(
                  onPressed: _resetFilters,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '초기화',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Apply Button
              Expanded(
                flex: 7,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '적용하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
