import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filter_bottom_sheet.dart';
import '../providers/job_providers.dart';

import '../../../l10n/gen/app_localizations.dart';

class JobFilterChips extends ConsumerWidget {
  const JobFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if any filters are active to potentially style the button differently
    final activeFilters = ref.watch(jobFilterProvider);
    final hasActiveFilters = activeFilters.isNotEmpty;
    final theme = ref.watch(jobThemeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows sheet to be taller if needed
            backgroundColor: Colors.transparent,
            builder: (context) => const FilterBottomSheet(),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: hasActiveFilters ? theme.primaryColor.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasActiveFilters ? theme.primaryColor : Colors.grey[300]!,
              width: 1,
            ),
             boxShadow: [
              BoxShadow(
                color: ref.watch(selectedJobCategoryProvider) == 1
                    ? const Color(0xFF1A237E).withValues(alpha: 0.3) // Indigo Shadow for Career
                    : const Color(0xFF26A69A).withValues(alpha: 0.35), // Mint Shadow for Part-Time
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Wrap content
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: hasActiveFilters ? theme.primaryColor : Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                activeFilters.isEmpty 
                  ? AppLocalizations.of(context)!.jobFilterTitle 
                  : AppLocalizations.of(context)!.jobFilterActive(activeFilters.length), // Show count if active
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasActiveFilters ? theme.primaryColor : Colors.grey[700],
                ),
              ),
              const Spacer(),
              if (hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.primaryColor,
                  ),
                ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: hasActiveFilters ? theme.primaryColor : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
