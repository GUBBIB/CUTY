import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../main_screen.dart';

class OnboardingTutorialScreen extends StatelessWidget {
  const OnboardingTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final l10n = AppLocalizations.of(context)!;
    final step = provider.currentStep;

    String getCharacterImage() {
      if (step == 3) return 'assets/images/capy_joy.png';
      return 'assets/images/capy_hello.png';
    }

    String getBackgroundImage() {
      switch (step) {
        case 0: return 'assets/images/bg_tutorial_room.jpg';
        case 1: return 'assets/images/bg_tutorial_park.jpg';
        case 2: return 'assets/images/bg_tutorial_campus.jpg';
        case 3: return 'assets/images/bg_tutorial_MainGate.jpg';
        default: return 'assets/images/bg_tutorial_park.jpg';
      }
    }

    String getDialogueMessage() {
      switch (step) {
        case 0: return l10n.tutorialWelcome;
        case 1: return l10n.tutorialNationality;
        case 2: return l10n.tutorialRegion;
        case 3: return l10n.tutorialSchool;
        default: return "";
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dynamic Background Image (Full Screen Cover)
          SizedBox.expand(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Image.asset(
                getBackgroundImage(),
                key: ValueKey<int>(step),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF2C2C4E));
                },
              ),
            ),
          ),

          // 2. Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. UI Components (Stack within SafeArea)
          SafeArea(
            child: Stack(
              children: [
                // [Character]
                Positioned(
                  bottom: 240, // Sit above the dialogue area
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset(
                      getCharacterImage(),
                      key: ValueKey<int>(step),
                      height: 320,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // [Dialogue Box containing Text AND Input]
                // [Dialogue Box containing Text AND Input]
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 215, maxHeight: 280), // Increased height for input
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2B4D).withOpacity(0.9), // Slightly higher opacity
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Dialogue Text
                               AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    getDialogueMessage(),
                                    key: ValueKey<int>(step),
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                
                                // Input Field (Embedded inside Dialogue)
                                if (step > 0) ...[
                                  const SizedBox(height: 16), // Spacing between text and input
                                  _buildSelectionContent(context, provider),
                                ],

                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildNextIconButton(context, provider),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Name Tag
                      Positioned(
                        top: -16,
                        left: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Text(
                            "Cutybara",
                            style: GoogleFonts.notoSansKr(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Widget _buildSelectionContent(BuildContext context, OnboardingProvider provider) {
    if (provider.currentStep == 1) {
      return _buildDropdown(
        hint: "Select Nationality",
        value: provider.nationality,
        items: provider.nationalities,
        onChanged: provider.updateNationality,
      );
    } else if (provider.currentStep == 2) {
      return _buildDropdown(
        hint: "Select Region",
        value: provider.region,
        items: provider.regions,
        onChanged: provider.updateRegion,
      );
    } else if (provider.currentStep == 3) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              "📍 Region: ${provider.region}",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          _buildDropdown(
            hint: "Select University",
            value: provider.school,
            items: provider.availableSchools,
            onChanged: provider.updateSchool,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      height: 50, // Fixed height for cleaner look inside dialogue
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint, style: TextStyle(color: Colors.white60, fontSize: 14)),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        isExpanded: true,
        menuMaxHeight: 300,
        dropdownColor: const Color(0xFF2C2C4E),
        style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // Centered vertically
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white30)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white30)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF8B5CF6))),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNextIconButton(BuildContext context, OnboardingProvider provider) {
    bool isEnabled = false;
    
    if (provider.currentStep == 0) isEnabled = true;
    else if (provider.currentStep == 1) isEnabled = provider.nationality != null;
    else if (provider.currentStep == 2) isEnabled = provider.region != null;
    else if (provider.currentStep == 3) isEnabled = provider.school != null;

    return GestureDetector(
      onTap: isEnabled ? () {
        if (provider.currentStep == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen(showTutorial: true)),
          );
        } else {
          provider.nextStep();
        }
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFF8B5CF6) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isEnabled ? [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.4), blurRadius: 8, spreadRadius: 1)] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.currentStep == 3 ? "Start" : "Next",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}
