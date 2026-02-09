import 'package:flutter/material.dart';

import 'widgets/job_app_bar.dart';
import 'widgets/job_category_tab.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/career_tab_content.dart';
import 'widgets/job_filter_chips.dart';
import 'widgets/job_list_view.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/gen/app_localizations.dart';
import 'providers/job_providers.dart';

class JobHomeScreen extends ConsumerWidget {
  const JobHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsyncValue = ref.watch(jobListProvider);
    final tabIndex = ref.watch(selectedJobCategoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const JobAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const JobCategoryTab(),
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, child) {
                    final tabIndex = ref.watch(selectedJobCategoryProvider);
                    return PromotionBanner(key: ValueKey(tabIndex));
                  },
                ),
                if (tabIndex == 1)
                  const CareerTabContent()
                else
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const JobFilterChips(),
                      const SizedBox(height: 16),

                      // Job List Section with State Handling
                      jobsAsyncValue.when(
                        data: (jobs) {
                          if (jobs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 50),
                              child: Column(
                                children: [
                                  const Icon(Icons.work_off, size: 48, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.msgNoJobs,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return JobListView(jobs: jobs);
                        },
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(child: Text('오류가 발생했습니다: $err')),
                        ),
                        loading: () => const _JobListSkeleton(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class _JobListSkeleton extends StatelessWidget {
  const _JobListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 24,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
