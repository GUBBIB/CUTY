import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view_model.dart';
import '../../providers/home_view_provider.dart';
import '../job/jobs_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/home_menu_grid.dart';
import 'widgets/schedule_list.dart';
import 'widgets/character_section.dart';
import 'widgets/community_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    // View Switching Logic
    if (ref.watch(homeViewProvider) == 'job') {
       return Container(
        color: Colors.white, // Job Screen Background
        width: double.infinity,
        height: double.infinity,
        child: const SafeArea(
          bottom: false,
          child: JobScreen(),
        ),
      );
    }

    // Default Dashboard View
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFEF5), // Bright Ivory
            Color(0xFFFFE4C4), // Warm Apricot/Beige
          ],
        ),
      ),
      // Modified SafeArea: bottom=false allows the white sheet to extend to the very bottom device edge
      child: SafeArea(
        bottom: false, 
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(homeViewModelProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 12, 0),
                  child: HomeHeader(),
                ),
                const HomeMenuGrid(),
                // [Layout Logic] Top Gap Added to Push Content Down (Re-balancing)
                const SizedBox(height: 30), 

                // [Z-Layered Hero Stack]
                SizedBox(
                  height: 345, // Reduced from 380 to pull everything up
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Layer 1: Schedule Card (Background Platform)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: const ScheduleList(),
                      ),
                      // Layer 2: Contact Shadow (Middle - On top of Card)
                      Positioned(
                        bottom: 80, // Lowered from 85 to match slimmer card
                        child: Container(
                          height: 6,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: const BorderRadius.all(Radius.elliptical(100, 10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Layer 3: Character (Front - Standing on everything)
                      Positioned(
                        bottom: 80, // Lowered from 85 for alignment
                        left: 0,
                        right: 0,
                        child: CharacterSection(
                          imagePath: state.characterImage,
                          message: "오늘도 힘내보자!",
                        ),
                      ),
                    ],
                  ),
                ),

                // Gap between Card and Community
                const SizedBox(height: 20),

                // [Community Section] - FULL WIDTH SHEET
                const CommunitySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
