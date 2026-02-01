import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classList = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('강의 시간표'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)), // Placeholder for add
        ],
      ),
      body: Column(
        children: [
          // 1. Header Row (Mon-Fri)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40), // Time column width
                ...List.generate(5, (index) {
                  final day = ["월", "화", "수", "목", "금"][index];
                  return Expanded(
                    child: Center(
                      child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          // 2. Time Grid
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Background Grid Lines
                  Column(
                    children: List.generate(9, (index) { // 9 AM to 6 PM
                      final time = index + 9;
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(
                                  "$time:00",
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()), // Grid cell content
                          ],
                        ),
                      );
                    }),
                  ),

                  // Class Items
                  ...classList.map((item) {
                     // Calculate position
                     // 1 hour = 60 pixels height. Start time 9:00 is offset 0.
                     // item.startTime (e.g., 10) -> (10-9) * 60
                     final top = (item.startTime - 9) * 60.0;
                     final height = item.duration * 60.0;
                     
                     // Width calculation: (ScreenWidth - 40) / 5
                     // We need LayoutBuilder for exact width, but flexible approach:
                     // We use Positioned with fractional calculation if possible, or simpler absolute logic.
                     // Since we are in Stack, let's assume fixed column width logic or use Row/Column approach.
                     // Actually, easiest valid way in Stack without known width is using left/right margins or `Positioned`.
                     // Let's use `LayoutBuilder` wrapping the Stack to be safe, but `SingleChildScrollView` complicates it.
                     // Simplified: Assume device width logic or use percentages roughly. 
                     // Better: `Row` with `Expanded` placeholders? No, items overlap cells.
                     // Best for "Simplicity": `Positioned` with relative coordinates.
                     
                     // Day 1(Mon) -> Index 0. 
                     // Left = 40 + (Day-1) * (Width/5)
                     // But we don't know Width inside this Stack easily without LayoutBuilder.
                     
                     // Alternative: Render grid using Row(Column(Cells)) structure instead of Stack?
                     // No, "Merge cells" is hard.
                     
                     // Let's use a LayoutBuilder OUTSIDE the SingleChildScrollView for width, then pass it down?
                     // Or just generic safe width.
                     
                     // Hacky but robust for "fast implementation":
                     // Use `Align` and `FractionallySizedBox`? 
                     // No, `Positioned` works best if we know constraints.
                     
                     // Let's stick to a simpler list view if grid is too complex? 
                     // User said "Schedule Screen", usually implies grid.
                     // Let's try `Positioned` with `left` and `width` based on `MediaQuery`.
                     
                     return Positioned(
                       top: top,
                       left: 40 + ((item.day - 1) * ((MediaQuery.of(context).size.width - 40) / 5)), // Approximate
                       width: (MediaQuery.of(context).size.width - 40) / 5,
                       height: height,
                       child: Container(
                         margin: const EdgeInsets.all(1),
                         padding: const EdgeInsets.all(4),
                         decoration: BoxDecoration(
                           color: item.color,
                           borderRadius: BorderRadius.circular(4),
                           border: Border.all(color: Colors.black12),
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               item.title,
                               style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                               textAlign: TextAlign.center,
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                             if (item.room.isNotEmpty)
                               Text(
                                 item.room,
                                 style: const TextStyle(fontSize: 8),
                                 textAlign: TextAlign.center,
                               ),
                           ],
                         ),
                       ),
                     );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
