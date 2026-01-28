import 'package:flutter/material.dart';

import 'widgets/job_app_bar.dart';
import 'widgets/job_category_tab.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/salary_dashboard.dart';
import 'widgets/job_list_view.dart';

class JobHomeScreen extends StatelessWidget {
  const JobHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const JobAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const JobCategoryTab(), // Moved inside for scroll behavior
                const SizedBox(height: 20),
                const PromotionBanner(),
                const SalaryDashboard(),
                const JobListView(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
