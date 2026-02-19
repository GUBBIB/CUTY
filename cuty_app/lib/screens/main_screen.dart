import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nav_provider.dart';
import 'home/home_screen.dart';
import 'mypage/my_page_screen.dart';
import 'home/widgets/home_bottom_nav_bar.dart';
import 'shop/shop_screen.dart';
import '../../l10n/gen/app_localizations.dart'; // [Added]
import 'home/widgets/tutorial_overlay.dart'; // [Added]

class MainScreen extends ConsumerStatefulWidget {
  final bool showTutorial;
  const MainScreen({super.key, this.showTutorial = false});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}



class _MainScreenState extends ConsumerState<MainScreen> {
  DateTime? currentBackPressTime;
  
  // Tutorial State
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _characterKey = GlobalKey();
  final GlobalKey _communityKey = GlobalKey();
  final GlobalKey _bottomNavKey = GlobalKey(); // [Added]
  int _tutorialStep = 0; // 0: None, 1: Menu, 2: Character, 3: Community, 4: BottomNav

  @override
  void initState() {
    super.initState();
    if (widget.showTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _tutorialStep = 1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 1) {
          ref.read(bottomNavIndexProvider.notifier).state = 1; 
          return false; 
        }

        final now = DateTime.now();
        if (currentBackPressTime == null || 
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한 번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: [
                ShopScreen(),       
                HomeScreen(
                  menuKey: _menuKey,
                  characterKey: _characterKey,
                  communityKey: _communityKey,
                ),       
                MyPageScreen(),     
              ],
            ),
            bottomNavigationBar: KeyedSubtree(
              key: _bottomNavKey, // [Added]
              child: const HomeBottomNavBar(),
            ),
          ),

          // [Tutorial Overlay]
          if (_tutorialStep > 0)
            TutorialOverlay(
              key: ValueKey(_tutorialStep),
              targetKey: _getTargetKey(_tutorialStep),
              text: _getTutorialText(_tutorialStep, context),
              isLastStep: _tutorialStep == 4,
              onNext: () {
                setState(() {
                  if (_tutorialStep < 4) {
                    _tutorialStep++;
                  } else {
                    _tutorialStep = 0; // Finish
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  GlobalKey _getTargetKey(int step) {
    switch (step) {
      case 1: return _menuKey;
      case 2: return _characterKey;
      case 3: return _communityKey;
      case 4: return _bottomNavKey;
      default: return _menuKey;
    }
  }

  String _getTutorialText(int step, BuildContext context) {
    switch (step) {
      case 1: return AppLocalizations.of(context)!.tutorialMainIntro;
      case 2: return AppLocalizations.of(context)!.tutorialCharacterIntro;
      case 3: return AppLocalizations.of(context)!.tutorialCommunityIntro;
      case 4: return AppLocalizations.of(context)!.tutorialBottomIntro;
      default: return "";
    }
  }
}
