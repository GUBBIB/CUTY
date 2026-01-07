import 'package:flutter/material.dart';

import 'package:cuty_app/common/component/schedule_ticket.dart';
import 'package:cuty_app/common/component/home_menu_card.dart';
import 'package:cuty_app/common/component/notice_banner.dart';
import 'package:cuty_app/common/component/speech_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main_screen_background.png'),
            fit: BoxFit.cover,
          )
        ),
        child: SafeArea(
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
                                        HomeMenuCard(backgroundColor: Color(0xFF1C3867), label: "Visa", icon: Image.asset('assets/images/Card/Card_Visa.png', width:50, height:50, fit: BoxFit.contain) ),
                                        const SizedBox(width: 12),
                                        HomeMenuCard(backgroundColor: Color(0xFFF6DF91), label: "Job/Alba", icon: Image.asset('assets/images/Card/Card_Bag.png', width:50, height:50, fit: BoxFit.contain) ),
                                        const SizedBox(width: 12),
                                        HomeMenuCard(backgroundColor: Color(0xFFFFFFFF), label: "School", icon: Image.asset('assets/images/Card/Card_Visa.png', width:50, height:50, fit: BoxFit.contain)),
                                        const SizedBox(width: 12),
                                        HomeMenuCard(backgroundColor: Color(0xFFC5E1AE), label: "오늘의 학식", icon: Image.asset('assets/images/Card/Card_Visa.png', width:50, height:50, fit: BoxFit.contain)),
                                        const SizedBox(width: 12),
                                        HomeMenuCard(backgroundColor: Color(0xFF1C3867), label: "더미 데이터", icon: Image.asset('assets/images/Card/Card_Visa.png', width:50, height:50, fit: BoxFit.contain)),
                                        const SizedBox(width: 12),
                                      ],
                                    )
                                )
                            )
                        )
                    ),

                    Expanded(
                      flex: 4,
                      child: Center(
                        child: SizedBox(
                          width: 300,
                          height: 400,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Image.asset(
                                  'assets/images/Character/Character_6.png',
                                  height: 300,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              Positioned(
                                right: 30,
                                bottom: 150,
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: Image.asset(
                                    'assets/images/pochuncookie.png',
                                    width: 60,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 40,
                                child: SpeechBubble(
                                  message: "오늘의 행운을 확인해봐!",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Expanded(
                        flex: 2,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScheduleTicket(startTime: "10:00 AM", subject: "Economic", room: "304"), // api 로 다음 수업 정보 들고와서 넣어야 함

                                    const SizedBox(height: 15),

                                    NoticeBanner(content: "TestContent", icon: "testIcon"),
                                  ],
                                )
                            )
                        )
                    )
                  ],
                )
            )
        ),
      )
    );
  }
}
