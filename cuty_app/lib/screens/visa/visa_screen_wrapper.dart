import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuty_app/services/local_storage_service.dart';
import '../../providers/visa_provider.dart';

// Screens
import 'visa_goal_selection_screen.dart';
import '../roadmap/visa_roadmap_screen.dart';
import 'employment_visa_screen.dart';
import 'startup_visa_screen.dart';
import 'global_visa_screen.dart';
import 'school_visa_screen.dart';

class VisaScreenWrapper extends StatefulWidget {
  const VisaScreenWrapper({super.key});

  @override
  State<VisaScreenWrapper> createState() => _VisaScreenWrapperState();
}

class _VisaScreenWrapperState extends State<VisaScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    // 1. 상태 구독
    final visaType = Provider.of<VisaProvider>(context).selectedVisaType;

    // 2. 상태에 따른 화면 반환
    if (visaType == 'none') {
      return VisaGoalSelectionScreen(
        onGoalSelected: (selectedGoal) {
          // 목표 선택 시 Provider 업데이트 및 로컬 저장
          context.read<VisaProvider>().selectVisaType(selectedGoal);
          LocalStorageService().saveUserGoal(selectedGoal);
        },
      );
    }

    switch (visaType) {
      case 'job':
      case 'employment':
        return const EmploymentVisaScreen();
      case 'startup':
        return const StartupVisaScreen();
      case 'global':
        return const GlobalVisaScreen();
      case 'novice':
      case 'student':
      case 'school':
        return const SchoolVisaScreen();
      case 'residency':
      case 'research':
        return VisaRoadmapScreen(
          userGoal: 'residency',
          onGoalChangeRequested: () {
            // 변경 요청 시 초기화
            context.read<VisaProvider>().selectVisaType('none');
            LocalStorageService().removeUserGoal();
          },
        );
      default:
        // 알 수 없는 타입이거나 기본값일 경우 F27(VisaRoadmap)으로 이동
         return VisaRoadmapScreen(
          userGoal: 'residency',
          onGoalChangeRequested: () {
            context.read<VisaProvider>().selectVisaType('none');
            LocalStorageService().removeUserGoal();
          },
        );
    }
  }
}
