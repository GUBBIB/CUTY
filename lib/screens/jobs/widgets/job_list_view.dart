import 'package:flutter/material.dart';
import '../../../../models/job_post.dart';
import '../../../../config/theme.dart';
import 'package:intl/intl.dart';

class JobListView extends StatelessWidget {
  const JobListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<JobPost> jobs = [
      JobPost(
        title: '부산 서면 카페 서빙',
        hourlyWage: 10000,
        tags: ['식사 제공', '한국어 상'],
        imageUrl: '', // Asset placeholder
        isVerified: true,
      ),
      JobPost(
        title: '센텀시티 아웃백스테이크',
        hourlyWage: 10500,
        tags: ['식사 제공', '한국어 중'],
        imageUrl: '',
        isVerified: true,
      ),
      JobPost(
        title: '해운대 편의점 야간',
        hourlyWage: 11000,
        tags: ['경력 무관'],
        imageUrl: '',
        isVerified: false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '맞춤 알바 공고',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // Nested in single scroll view
            shrinkWrap: true,
            itemCount: jobs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _JobCard(job: jobs[index]);
            },
          ),
          const SizedBox(height: 40), // Bottom padding
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobPost job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.zero, // Padding handling inside InkWell or outside?
      // Better to wrap Container contents with InkWell
      clipBehavior: Clip.hardEdge, // Ensure ripple respects radius
      child: InkWell(
        onTap: () {
          debugPrint('${job.title} Click!');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: job.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          job.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.store, color: Colors.grey[400]),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(Icons.store, color: Colors.grey[400]),
                      ),
              ),

              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '시급 ${currencyFormat.format(job.hourlyWage)}원↑',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: job.tags.map((tag) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
