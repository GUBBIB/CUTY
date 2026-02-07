import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/schedule_provider.dart';
import '../../models/schedule_model.dart';
import 'dart:math';
import '../../l10n/gen/app_localizations.dart'; // Add localization import

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classList = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('강의 시간표'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final timeColWidth = 40.0;
          final cellWidth = (width - timeColWidth) / 7; // 7일 기준

          return Column(
            children: [
              // 1. Header Row (Mon-Sun)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: timeColWidth), // Time column width
                    ...List.generate(7, (index) {
                      final days = [
                        AppLocalizations.of(context)!.scheduleDayMon,
                        AppLocalizations.of(context)!.scheduleDayTue,
                        AppLocalizations.of(context)!.scheduleDayWed,
                        AppLocalizations.of(context)!.scheduleDayThu,
                        AppLocalizations.of(context)!.scheduleDayFri,
                        AppLocalizations.of(context)!.scheduleDaySat,
                        AppLocalizations.of(context)!.scheduleDaySun,
                      ];
                      return SizedBox(
                        width: cellWidth,
                        child: Center(
                          child: Text(
                              days[index], 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: index >= 5 ? Colors.red : Colors.black, // 주말 빨간색
                              )
                          ),
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
                        children: List.generate(12, (index) { // 9 AM to 8 PM (12 hours)
                          final time = index + 9;
                          return Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: timeColWidth,
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
                         final top = (item.startTime - 9) * 60.0;
                         final height = item.duration * 60.0;
                         
                         // Map "Mon" -> 0, "Tue" -> 1 ...
                         final dayMap = {"Mon": 0, "Tue": 1, "Wed": 2, "Thu": 3, "Fri": 4, "Sat": 5, "Sun": 6};
                         final dayIndex = dayMap[item.day] ?? 0;
                         
                         final left = timeColWidth + (dayIndex * cellWidth);
                         
                         return Positioned(
                           top: top,
                           left: left,
                           width: cellWidth,
                           height: height,
                           child: Container(
                             margin: const EdgeInsets.all(1),
                             padding: const EdgeInsets.all(2), // 1. Reduced Padding
                             decoration: BoxDecoration(
                               color: Colors.blue[100], // Default color since model has no color
                               borderRadius: BorderRadius.circular(4),
                               border: Border.all(color: Colors.black12),
                             ),
                             child: FittedBox( // 2. FittedBox for auto-scaling
                               fit: BoxFit.scaleDown,
                               alignment: Alignment.center, // Center alignment looks better usually
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text(
                                     item.title,
                                     style: const TextStyle(
                                         fontSize: 11, // 3. Reduced Font Size
                                         fontWeight: FontWeight.bold
                                     ),
                                     textAlign: TextAlign.center,
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   if (item.classroom.isNotEmpty)
                                     Text(
                                       item.classroom,
                                       style: const TextStyle(fontSize: 9), // 3. Reduced Font Size
                                       textAlign: TextAlign.center,
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                 ],
                               ),
                             ),
                           ),
                         );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showAddClassDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final roomController = TextEditingController();
    int selectedDay = 1; // Mon
    int selectedTime = 9; // 9 AM
    int selectedDuration = 1; // 1 Hour

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.scheduleAddTitle), // "수업 추가"
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.scheduleFieldTitle),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: roomController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.scheduleFieldRoom),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text("${AppLocalizations.of(context)!.scheduleFieldDay}: "),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: selectedDay,
                          items: List.generate(7, (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text([
                              AppLocalizations.of(context)!.scheduleDayMon,
                              AppLocalizations.of(context)!.scheduleDayTue,
                              AppLocalizations.of(context)!.scheduleDayWed,
                              AppLocalizations.of(context)!.scheduleDayThu,
                              AppLocalizations.of(context)!.scheduleDayFri,
                              AppLocalizations.of(context)!.scheduleDaySat,
                              AppLocalizations.of(context)!.scheduleDaySun,
                            ][index]),
                          )),
                          onChanged: (val) => setState(() => selectedDay = val!),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("${AppLocalizations.of(context)!.scheduleFieldTime}: "),
                        const SizedBox(width: 8),
                         DropdownButton<int>(
                          value: selectedTime,
                          items: List.generate(12, (index) => DropdownMenuItem( // 9 to 20
                            value: index + 9,
                            child: Text("${index + 9}:00"),
                          )),
                          onChanged: (val) => setState(() => selectedTime = val!),
                        ),
                      ],
                    ),
                    Row(
                       children: [
                        Text("${AppLocalizations.of(context)!.scheduleFieldDuration}: "),
                        const SizedBox(width: 8),
                         DropdownButton<int>(
                          value: selectedDuration,
                          items: [1, 2, 3, 4].map((e) => DropdownMenuItem(value: e, child: Text("$e Hour(s)"))).toList(),
                          onChanged: (val) => setState(() => selectedDuration = val!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.commonCancel)),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) return;
                    
                    final dayMap = {1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat", 7: "Sun"};

                    final newItem = Schedule(
                      id: Random().nextInt(10000), // Random ID
                      title: titleController.text,
                      classroom: roomController.text,
                      day: dayMap[selectedDay] ?? "Mon",
                      startTime: selectedTime,
                      duration: selectedDuration,
                    );
                    
                    final success = ref.read(scheduleProvider.notifier).addClass(newItem);
                    Navigator.pop(context);
                    
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("수업이 등록되었습니다.")));
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("해당 시간에 이미 수업이 있습니다.")));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.commonConfirm),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
