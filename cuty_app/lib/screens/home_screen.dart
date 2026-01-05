import 'package:flutter/material.dart';

import 'package:cuty_app/common/component/schedule_ticket.dart';
import 'package:cuty_app/common/component/home_menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EFD4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            HomeMenuCard(backgroundColor: Color(0xFF1C3867), label: "Visa", icon: Icon(Icons.work_outline, color: Colors.black, size: 30) ),
                            const SizedBox(width: 12),
                            HomeMenuCard(backgroundColor: Color(0xFFF6DF91), label: "Job/Alba", icon: Icon(Icons.work_outline, color: Colors.black, size: 30)),
                            const SizedBox(width: 12),
                            HomeMenuCard(backgroundColor: Color(0xFFFFFFFF), label: "School", icon: Icon(Icons.work_outline, color: Colors.black, size: 30)),
                            const SizedBox(width: 12),
                            HomeMenuCard(backgroundColor: Color(0xFFC5E1AE), label: "오늘의 학식", icon: Icon(Icons.work_outline, color: Colors.black, size: 30)),
                            const SizedBox(width: 12),
                            HomeMenuCard(backgroundColor: Color(0xFF1C3867), label: "더미 데이터", icon: Icon(Icons.work_outline, color: Colors.black, size: 30)),
                            const SizedBox(width: 12),
                          ],
                        )
                    )
                  )
                )
              ),

              Expanded(
                flex: 4,
                child: Container(),
              ),

              const Expanded(
                flex: 2,
                child: Center(
                  child: ScheduleTicket(startTime: "10:00 AM", subject: "Economic", room: "304"),
                )
              )
            ],
          )
      )
      ),
    );
  }
}
