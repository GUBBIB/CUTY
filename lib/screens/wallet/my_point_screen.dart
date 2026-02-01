import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/point_provider.dart';

class MyPointScreen extends ConsumerWidget {
  const MyPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointState = ref.watch(pointProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('포인트 내역', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 1. Total Balance Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            child: Column(
              children: [
                const Text('현재 보유 포인트', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '${NumberFormat('#,###').format(pointState.totalBalance)} P',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),

          // 2. Mission Banners (Horizontal Scroll)
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMissionCard(
                  context,
                  title: "서류 등록하고",
                  reward: "300P",
                  icon: Icons.description_outlined,
                  color: const Color(0xFFE3F2FD), // Light Blue
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("DocumentProvider 연동 예정 📄"))),
                ),
                const SizedBox(width: 12),
                _buildMissionCard(
                  context,
                  title: "면접 후기 쓰고",
                  reward: "500P",
                  icon: Icons.rate_review_outlined,
                  color: const Color(0xFFF3E5F5), // Light Purple
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AlbaProvider 연동 예정 🎤"))),
                ),
              ],
            ),
          ),
          
          const Divider(height: 40, thickness: 8, color: Color(0xFFF5F5F5)),

          // 3. History List
          Expanded(
            child: pointState.history.isEmpty
            ? const Center(child: Text("아직 적립된 포인트가 없어요!"))
            : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: pointState.history.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final history = pointState.history[index];
                final isEarned = history.type == 'earn';
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            history.title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MM.dd HH:mm').format(history.date),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        '${isEarned ? '+' : ''}${NumberFormat('#,###').format(history.amount)} P',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isEarned ? const Color(0xFF8B5CF6) : const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, {required String title, required String reward, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.black54),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black26),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(reward, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
