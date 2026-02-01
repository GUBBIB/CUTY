import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/point_provider.dart';

class MyPointScreen extends ConsumerWidget {
  const MyPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointState = ref.watch(pointProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('포인트 내역'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: const Color(0xFFF3E5F5), // Light purple background
            child: Column(
              children: [
                const Text('현재 보유 포인트', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '${pointState.totalBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} P',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: pointState.history.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final history = pointState.history[index];
                final isEarned = history['amount'] > 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isEarned ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    child: Icon(
                      isEarned ? Icons.add : Icons.remove,
                      color: isEarned ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(history['description']),
                  subtitle: Text(history['date']),
                  trailing: Text(
                    '${isEarned ? '+' : ''}${history['amount']} P',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isEarned ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
