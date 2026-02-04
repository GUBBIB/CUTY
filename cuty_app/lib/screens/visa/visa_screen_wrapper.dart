import 'package:flutter/material.dart';
import 'visa_goal_selection_screen.dart';
import 'package:cuty_app/services/local_storage_service.dart';
import '../roadmap/visa_roadmap_screen.dart';

// Mock State for session persistence
class VisaState {
  static String? userGoal;
}

class VisaScreenWrapper extends StatefulWidget {
  const VisaScreenWrapper({super.key});

  @override
  State<VisaScreenWrapper> createState() => _VisaScreenWrapperState();
}

class _VisaScreenWrapperState extends State<VisaScreenWrapper> {
  
  @override
  void initState() {
    super.initState();
    _loadUserGoal();
  }

  void _loadUserGoal() {
    final savedGoal = LocalStorageService().getUserGoal();
    if (savedGoal != null) {
      VisaState.userGoal = savedGoal;
    }
  }

  void _updateGoal(String? goal) {
    setState(() {
      VisaState.userGoal = goal;
    });
    if (goal != null) {
      LocalStorageService().saveUserGoal(goal);
    } else {
      LocalStorageService().removeUserGoal();
    }
  }

  @override
  Widget build(BuildContext context) {
    // If goal is null, show selection screen
    if (VisaState.userGoal == null) {
      return VisaGoalSelectionScreen(
        onGoalSelected: (selectedGoal) {
          _updateGoal(selectedGoal);
        },
      );
    } 
    // Otherwise, show dashboard (now Roadmap)
    else {
      return VisaRoadmapScreen(
        userGoal: VisaState.userGoal!,
        onGoalChangeRequested: () {
          _updateGoal(null); // Reset goal to trigger selection screen
        },
      );
    }
  }
}
