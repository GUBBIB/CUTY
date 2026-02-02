import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/schedule_provider.dart';
import '../../../../models/schedule_item.dart';
import 'schedule_card.dart';

class ScheduleList extends ConsumerWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get next class from ScheduleProvider
    final notifier = ref.watch(scheduleProvider.notifier);
    final nextClass = notifier.getNextClass();

    // 2. Map to UI Model (ScheduleItem)
    // If title is empty, it means 'No Class' or 'End of Day'
    // If title is empty, it means 'No Class' or 'End of Day'
    if (nextClass?.title.isEmpty ?? true) {
        return ScheduleCard(item: ScheduleItem(
          title: "오늘 수업 끝! 🎉",
          time: "--:--",
          subtitle: "푹 쉬세요!",
        ));
    }

    final displayItem = ScheduleItem(
      title: nextClass?.title ?? '수업 없음',
      time: "${nextClass?.startTime ?? 9}:00", // Convert int hour to string time
      subtitle: nextClass?.classroom ?? '', // Room maps to subtitle
    );

    return ScheduleCard(item: displayItem);
  }
}
