import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cuty_app/l10n/gen/app_localizations.dart';
import 'package:cuty_app/screens/visa/premium_purchase_screen.dart';
import 'dart:math' as math;

class PremiumLandingScreen extends StatelessWidget {
  const PremiumLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // [Safety Check]
    if (l10n == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Navy
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(child: _buildAnimatedBackground()),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMassiveHero(context, l10n),
                _buildStatTicker(context, l10n),
                
                // STEP 1: Process
                _buildProcessSection(context, l10n),

                // STEP 2: AI Strategy Generation (Refined)
                _buildStrategyGenerationSection(context, l10n),
                
                // STEP 3: Advanced Milestone Management
                _buildAdvancedRoadmapSection(context, l10n),

                // STEP 4: Corporate Connection
                _buildCorporateConnectionSection(context, l10n),

                _buildFaqSection(context, l10n),
                const SizedBox(height: 180),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar(context, l10n)),
          Positioned(top: 50, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }

  // Animated Background
  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Positioned(top: -200, left: -200, child: _buildGradientBlob(Colors.indigoAccent)),
        Positioned(bottom: 200, right: -200, child: _buildGradientBlob(Colors.tealAccent)),
        Positioned(bottom: -300, left: 100, child: _buildGradientBlob(Colors.cyanAccent)),
      ],
    );
  }

  Widget _buildGradientBlob(Color color) {
    return Container(
      width: 600, height: 600,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.08), boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 150, spreadRadius: 50)]),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1,1), end: const Offset(1.2, 1.2), duration: 8.seconds);
  }

  // 1. Massive KVTI Hero
  Widget _buildMassiveHero(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 850,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(30), color: Colors.white.withOpacity(0.05)),
             child: Text(l10n.webHeroBadge, style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
           ).animate().fadeIn().slideY(begin: -0.5, end: 0),
           
           const SizedBox(height: 40),
           // Massive Title
           ShaderMask(
             shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Colors.cyanAccent]).createShader(bounds),
             child: Text(l10n.webHeroTitle, style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.w900, height: 1, letterSpacing: -2)),
           ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack),
           
           const SizedBox(height: 30),
           Text(l10n.webHeroSub, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[300], fontSize: 18, height: 1.6)).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
           
           const SizedBox(height: 60),
           // Scroll Indication
           const Column(children: [Text("SCROLL", style: TextStyle(color: Colors.white30, fontSize: 10, letterSpacing: 4)), SizedBox(height: 8), Icon(Icons.keyboard_arrow_down, color: Colors.white30)]).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 1.seconds).fadeOut(delay: 1.seconds),
        ],
      ),
    );
  }

  // Stat Ticker
  Widget _buildStatTicker(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(l10n.webStat1, l10n.webStat1Label),
          Container(width: 1, height: 30, color: Colors.white12),
          _buildStatItem(l10n.webStat2, l10n.webStat2Label),
          Container(width: 1, height: 30, color: Colors.white12),
          _buildStatItem(l10n.webStat3, l10n.webStat3Label),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(children: [Text(value, style: const TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12))]);
  }

  // Story 1: Diagnosis (Bento)
  Widget _buildProcessSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("STEP 01", style: TextStyle(color: Colors.cyanAccent.withOpacity(0.8), fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(l10n.webProcessTitle, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(l10n.webProcessSub, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          const SizedBox(height: 50),
          _buildBentoGrid(context, l10n),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Row(children: [Expanded(flex: 3, child: _buildBentoCard(l10n.webStep1, l10n.webStep1Desc, Icons.search, Colors.blue)), const SizedBox(width: 12), Expanded(flex: 2, child: _buildBentoCard(l10n.webStep2, l10n.webStep2Desc, Icons.bolt, Colors.amber))]),
        const SizedBox(height: 12),
        Row(children: [Expanded(flex: 2, child: _buildBentoCard(l10n.webStep3, l10n.webStep3Desc, Icons.check_circle, Colors.green)), const SizedBox(width: 12), Expanded(flex: 3, child: _buildBentoCard(l10n.webStep4, l10n.webStep4Desc, Icons.business, Colors.purple))]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _buildBentoCard(l10n.webStep5, l10n.webStep5Desc, Icons.people, Colors.teal)), const SizedBox(width: 12), Expanded(child: _buildBentoCard(l10n.webStep6, l10n.webStep6Desc, Icons.flag, Colors.redAccent))]),
      ],
    );
  }

  Widget _buildBentoCard(String title, String desc, IconData icon, Color color) {
    return Container(
      height: 160, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF161F2C), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: color, size: 30), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title.split('. ')[1].split(' (')[0], maxLines: 1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(desc, maxLines: 2, style: TextStyle(color: Colors.grey[500], fontSize: 12))])]),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  // Story 2: AI Strategy Generation (Refined)
  Widget _buildStrategyGenerationSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.black.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("STEP 02", style: TextStyle(color: Colors.purpleAccent.withOpacity(0.8), fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  Text(l10n.webStrategyTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              // Floating Icon
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 30)).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.webStrategySub, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          const SizedBox(height: 60),

          // Visualization: Data Processing -> Report Generation
          Center(
            child: Container(
              height: 380, width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Data Processing Circle (Rotating)
                  Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white10, width: 1))).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),
                  Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24, width: 1, style: BorderStyle.solid))).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(duration: 8.seconds, begin: 1, end: 0),
                  
                  // 2. Processing Text Sequence
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProcessingText(l10n.webStrategyProcessing1, 0, 1500),
                      const SizedBox(height: 8),
                      _buildProcessingText(l10n.webStrategyProcessing2, 1600, 3100),
                    ],
                  ),
                  
                  // 3. Final Result Report Card (Appears after processing)
                  _buildStrategyResultCard("TARGET: E-7-1", "PROBABILITY: 87%", Colors.green).animate(onPlay: (c) => c.repeat()).fadeIn(delay: 3200.ms).slideY(begin: 0.2, end: 0, delay: 3200.ms).fadeOut(delay: 6000.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingText(String text, int startMs, int endMs) {
    return Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 14)).animate(onPlay: (c) => c.repeat()).fadeIn(delay: startMs.ms).fadeOut(delay: endMs.ms);
  }

  Widget _buildStrategyResultCard(String title, String score, Color color) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 30)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics, color: Colors.cyanAccent, size: 40),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(score, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 24)),
        ],
      ),
    );
  }

  // Story 3: Advanced Milestone Management
  Widget _buildAdvancedRoadmapSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("STEP 03", style: TextStyle(color: Colors.greenAccent.withOpacity(0.8), fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(l10n.webRoadmapTitle, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(l10n.webRoadmapSub, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          const SizedBox(height: 60),
          
          _buildMilestoneCard(1, "1-2 YEAR", l10n.webRoadmapStep1, l10n.webRoadmapStep1Desc, Colors.blueGrey),
          _buildMilestoneCard(2, "3rd YEAR", l10n.webRoadmapStep2, l10n.webRoadmapStep2Desc, Colors.teal),
          _buildMilestoneCard(3, "4th YEAR", l10n.webRoadmapStep3, l10n.webRoadmapStep3Desc, Colors.green),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(int step, String badge, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF161F2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: step == 3 ? color : Colors.white.withOpacity(0.05), width: step == 3 ? 1 : 0.5),
        boxShadow: step == 3 ? [BoxShadow(color: color.withOpacity(0.1), blurRadius: 40)] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(badge, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(height: 16),
          Text(title.split(': ')[1], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc.split('\n')[0], style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.5)),
          const SizedBox(height: 16),
          // Quote
          if (desc.contains('\n'))
            Container(
               width: double.infinity,
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
               child: Text(desc.split('\n')[1].replaceAll('"', ''), style: TextStyle(color: color.withOpacity(0.8), fontStyle: FontStyle.italic, fontSize: 13)),
            ),
        ],
      ),
    ).animate().fadeIn(delay: (step * 200).ms).slideX();
  }

  // Story 4: Corporate Connection (Network)
  Widget _buildCorporateConnectionSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.blueAccent.withOpacity(0.08)])),
      child: Column(
        children: [
          Text("STEP 04", style: TextStyle(color: Colors.amberAccent.withOpacity(0.8), fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(l10n.webMatchTitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
          Text(l10n.webMatchSub, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 16, height: 1.5)),
          const SizedBox(height: 80),

          // Connection Visualization
          SizedBox(
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User (Gold)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 40)]), child: const Icon(Icons.person, color: Colors.black, size: 40)),
                    const SizedBox(height: 20),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)), child: const Text("Verified Talent", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                
                // Connecting Lines
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(height: 2, color: Colors.white10, width: double.infinity),
                      // Particles moving right
                      ...List.generate(3, (i) => Align(alignment: Alignment.centerLeft, child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.amberAccent, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).moveX(begin: 0, end: 150, duration: 1.5.seconds, delay: (i*300).ms).fadeOut(delay: 1.seconds))),
                    ],
                  ),
                ),

                // Companies (Network)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCompanyLogo(Colors.blue, Icons.business),
                    const SizedBox(height: 20),
                    _buildCompanyLogo(Colors.purple, Icons.apartment),
                    const SizedBox(height: 20),
                    _buildCompanyLogo(Colors.teal, Icons.domain),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(Color color, IconData icon) {
    return Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.5))), child: Icon(icon, color: color, size: 24)).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: 2.seconds);
  }

  Widget _buildFaqSection(BuildContext context, AppLocalizations l10n) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.webFaqTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 20), _buildAccordion(context, l10n.webFaq1Q, l10n.webFaq1A), _buildAccordion(context, l10n.webFaq2Q, l10n.webFaq2A)]));
  }

  Widget _buildAccordion(BuildContext context, String q, String a) => Container(margin: const EdgeInsets.only(bottom: 12), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))), child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: ExpansionTile(title: Text(q, style: const TextStyle(color: Colors.white)), iconColor: Colors.white, children: [Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(a.replaceAll('\n', ' '), style: const TextStyle(color: Colors.grey)))])));

  Widget _buildBottomBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(color: Color(0xFF0F172A), border: Border(top: BorderSide(color: Colors.white10)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))]),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("TOTAL MANAGEMENT", style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)), Text(l10n.webCtaPrice, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))])),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PremiumPurchaseScreen()),
              );
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)), 
            child: Text(l10n.webCtaButton, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter { final Color color; _HexagonPainter(this.color); @override void paint(Canvas canvas, Size size) { final paint = Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 2; final center = Offset(size.width/2, size.height/2); final radius = size.width/2; final path = Path(); for(int i=0;i<6;i++){ final angle = (i*60)*math.pi/180; final x = center.dx+radius*math.cos(angle); final y = center.dy+radius*math.sin(angle); if(i==0) path.moveTo(x,y); else path.lineTo(x,y); } path.close(); canvas.drawPath(path, paint); canvas.drawPath(path, Paint()..color = color.withOpacity(0.1)); } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false; }
