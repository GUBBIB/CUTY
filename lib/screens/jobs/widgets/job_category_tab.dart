import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/job_providers.dart';

class JobCategoryTab extends ConsumerStatefulWidget {
  const JobCategoryTab({super.key});

  @override
  ConsumerState<JobCategoryTab> createState() => _JobCategoryTabState();
}

class _JobCategoryTabState extends ConsumerState<JobCategoryTab> {
  // Local state not needed if fully driving from provider, but setState used for animation might benefit from local + sync. 
  // Let's rely on provider.

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedJobCategoryProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: [
          _buildTab('알바', '(Part-Time)', 0, selectedIndex, ref),
          _buildTab('취업', '(Career)', 1, selectedIndex, ref),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String subtitle, int index, int selectedIndex, WidgetRef ref) {
    final bool isSelected = selectedIndex == index;
    final theme = ref.watch(jobThemeProvider);

    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(selectedJobCategoryProvider.notifier).state = index;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? theme.primaryColor : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? theme.primaryColor : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
