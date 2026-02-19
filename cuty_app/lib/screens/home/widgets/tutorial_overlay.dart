import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/gen/app_localizations.dart';

class TutorialOverlay extends StatefulWidget {
  final GlobalKey targetKey;
  final String text;
  final VoidCallback onNext;
  final bool isLastStep;

  const TutorialOverlay({
    super.key,
    required this.targetKey,
    required this.text,
    required this.onNext,
    this.isLastStep = false,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTargetRect();
    });
  }

  void _calculateTargetRect() {
    final RenderBox? renderBox = widget.targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _targetRect = Rect.fromLTWH(position.dx - 8, position.dy - 8, size.width + 16, size.height + 16);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_targetRect == null) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    
    // Determine if dialogue should be at top or bottom
    final isTargetAtBottom = (_targetRect!.center.dy > size.height * 0.6);
    final double? topPosition = isTargetAtBottom ? 60 : null; 
    final double? bottomPosition = isTargetAtBottom ? null : 32;

    return Stack(
      children: [
        // 1. Dark Overlay with Hole
        ClipPath(
          clipper: _SpotLightClipper(targetRect: _targetRect!),
          child: Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ),

        // 3. Dialogue Box
        Positioned(
          top: topPosition,
          bottom: bottomPosition,
          left: 16,
          right: 16,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 100, maxHeight: 260),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2B4D).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.text,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: widget.onNext,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.btnNext,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                                ],
                              ),
                            ),
                          ),
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
                    ),
                    child: Text(
                      "Cutybara",
                      style: GoogleFonts.notoSansKr(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SpotLightClipper extends CustomClipper<Path> {
  final Rect targetRect;

  _SpotLightClipper({required this.targetRect});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(targetRect, const Radius.circular(24)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
