import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/diagnosis_provider.dart';
import '../../models/diagnosis_model.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosisProvider);
    final result = state.result ?? DiagnosisResult.empty();
    
    // Sort: Green -> Yellow -> Red
    final jobResultList = result.analysisResults.values.toList()
      ..sort((a, b) => a.visaStatus.index.compareTo(b.visaStatus.index));

    if (jobResultList.isEmpty) {
      return const Scaffold(body: Center(child: Text("분석 결과가 없습니다.")));
    }

    final totalTabs = 1 + jobResultList.length;

    return DefaultTabController(
      length: totalTabs,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("진단 결과 리포트"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.indigo,
            tabAlignment: TabAlignment.startOffset,
            tabs: [
              // 1. Total Score Tab
              const Tab(
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("종합 역량"),
                  ],
                ),
              ),
              // 2. Job Tabs
              ...jobResultList.map((job) {
                 return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(_getStatusIcon(job.visaStatus), size: 16, color: _getStatusColor(job.visaStatus)),
                         const SizedBox(width: 8),
                         Text("${job.jobName} (${job.jobCode})"),
                      ],
                    ),
                 );
              }),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // View A: Total Score
            // View A: Total Score
            _buildTotalResultView(context, result),
            // View B: Job Details
            ...jobResultList.map((jobData) => _buildJobDetailView(context, jobData, result.solutionDocs)),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalResultView(BuildContext context, DiagnosisResult result) {
    // 1. Prepare Donut Chart Data
    final double score = result.totalScore.toDouble();
    final double remaining = 100 - score;
    
    // Calculate section values for display
    final int valLang = (score * 0.4).round();
    final int valExp = (score * 0.3).round();
    final int valMajor = (score * 0.3).round();

    // 2. Prepare Radar Data (5 Axes)
    final primary = result.primary;
    Map<String, int> my5Scores = {};
    Map<String, int> avg5Scores = {};
    
    if (primary != null) {
      my5Scores = {
        "언어": primary.myScores["언어"] ?? 0,
        "전공": primary.myScores["전문성"] ?? 0,
        "경력": primary.myScores["경력"] ?? 0,
        "자격": primary.myScores["성실성"] ?? 0,
        "문화": primary.myScores["한국이해"] ?? 0,
      };
      avg5Scores = {
        "언어": primary.avgScores["언어"] ?? 80,
        "전공": primary.avgScores["전문성"] ?? 80,
        "경력": primary.avgScores["경력"] ?? 70,
        "자격": primary.avgScores["성실성"] ?? 70,
        "문화": primary.avgScores["한국이해"] ?? 70,
      };
    }

    // 3. AI Comment Logic
    String advice = "모든 역량이 균형 잡혀있습니다!";
    String bestJobName = primary?.jobName ?? "IT 전문가";
    
    if (my5Scores.isNotEmpty) {
       var sortedEntries = my5Scores.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
       var weakest = sortedEntries.first;
       
       switch(weakest.key) {
         case "언어": advice = "하지만 **한국어 능력**을 조금 더 보완하면 합격률이 급상승할 거예요!"; break;
         case "전공": advice = "하지만 **전공 관련 학점**이나 프로젝트 경험을 더 어필해보세요!"; break;
         case "경력": advice = "하지만 관련 **인턴십 경력**을 한 번 더 쌓는 것을 추천해요!"; break;
         case "자격": advice = "하지만 **직무 관련 자격증**이나 성실성을 증명할 서류를 챙겨보세요!"; break;
         case "문화": advice = "하지만 **한국 문화 이해도**를 높이는 활동(봉사 등)이 도움이 될 거예요!"; break;
       }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // -----------------------------------------------------------------
          // 1. Comprehensive Donut Chart
          // -----------------------------------------------------------------
          Center(
            child: SizedBox(
              height: 220,
              child: Stack(
                children: [
                   PieChart(
                     PieChartData(
                       sectionsSpace: 4,
                       centerSpaceRadius: 70,
                       startDegreeOffset: 270,
                       sections: [
                         PieChartSectionData(color: Colors.indigo, value: valLang.toDouble(), radius: 20, showTitle: false),
                         PieChartSectionData(color: Colors.teal, value: valExp.toDouble(), radius: 20, showTitle: false),
                         PieChartSectionData(color: Colors.orange, value: valMajor.toDouble(), radius: 20, showTitle: false),
                         if (remaining > 0)
                           PieChartSectionData(color: Colors.grey[200], value: remaining, radius: 15, showTitle: false),
                       ],
                     ),
                   ),
                   Center(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Text(
                           "${result.totalScore}", 
                           style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.indigo)
                         ),
                         const Text("점 / 100", style: TextStyle(fontSize: 14, color: Colors.grey)),
                         const SizedBox(height: 4),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                           decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                           child: Text(result.totalTier, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                         )
                       ],
                     ),
                   ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Chart Legend
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50], 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(Colors.indigo, "한국어", valLang),
                _buildLegendItem(Colors.teal, "실무경력", valExp),
                _buildLegendItem(Colors.orange, "전공/자격", valMajor),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // -----------------------------------------------------------------
          // 2. Job Suitability Ranking
          // -----------------------------------------------------------------
          const Text("🏆 직무별 매칭 점수", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...result.analysisResults.values.map((job) {
             double avg = job.myScores.values.reduce((a, b) => a + b) / 5;
             double displayScore = avg.clamp(0, 100);
             
             return Padding(
               padding: const EdgeInsets.only(bottom: 12.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("${job.jobName} (${job.jobCode})", style: const TextStyle(fontWeight: FontWeight.w600)),
                       Text("${displayScore.toInt()}점", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                     ],
                   ),
                   const SizedBox(height: 6),
                   ClipRRect(
                     borderRadius: BorderRadius.circular(4),
                     child: LinearProgressIndicator(
                       value: displayScore / 100,
                       backgroundColor: Colors.grey[200],
                       color: _getStatusColor(job.visaStatus),
                       minHeight: 8,
                     ),
                   ),
                 ],
               ),
             );
          }),
          const SizedBox(height: 40),

          // -----------------------------------------------------------------
          // 3. 5-Axis Radar Chart
          // -----------------------------------------------------------------
          const Text("📊 기초 역량 분석 (5대 요소)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (my5Scores.isNotEmpty)
             SizedBox(
               height: 300,
               width: double.infinity,
               child: CustomPaint(
                 painter: RadarChartPainter(my5Scores, avg5Scores),
               ),
             ),
          
          const SizedBox(height: 30),

          // -----------------------------------------------------------------
          // 4. AI Consultant Comment
          // -----------------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5), // Lavender Light
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
                    SizedBox(width: 8),
                    Text("AI 컨설턴트 한마디", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "현재 분석 결과, "),
                      TextSpan(
                        text: bestJobName, 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
                      ),
                      const TextSpan(text: " 직무가 가장 적합해 보입니다.\n"),
                      TextSpan(text: advice),
                    ],
                    style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // -----------------------------------------------------------------
          // 5. Action Buttons
          // -----------------------------------------------------------------
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.work, color: Colors.white),
              label: const Text("맞춤 공고 보러가기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton.icon(
              onPressed: () => debugPrint(">>> [클릭] 결과 공유하기"),
              icon: const Icon(Icons.share, color: Colors.grey),
              label: const Text("결과 공유하기", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int score) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(width: 4),
        Text("$score점", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }


  Widget _buildJobDetailView(BuildContext context, JobAnalysisData data, List<String> docs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Card
          // 1. Header Card
          const Text("비자 발급 요건 충족 여부", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getStatusColor(data.visaStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _getStatusColor(data.visaStatus)),
            ),
            child: Row(
              children: [
                 Icon(_getStatusIcon(data.visaStatus), size: 40, color: _getStatusColor(data.visaStatus)),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(data.jobCode, style: TextStyle(color: _getStatusColor(data.visaStatus), fontWeight: FontWeight.bold)),
                       Text(data.jobName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                       Text(_getStatusMessage(data.visaStatus), style: TextStyle(fontSize: 12, color: _getStatusColor(data.visaStatus))),
                     ],
                   ),
                 )
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 2. Benchmarking Radar Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("합격자 평균 비교 분석", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              Row(
                children: [
                  _legendItem(Colors.blue, "내 점수"),
                  const SizedBox(width: 12),
                  // Lavender Legend
                  _legendItem(Colors.purple, "합격자 평균", isDashed: false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CustomPaint(
              painter: RadarChartPainter(data.myScores, data.avgScores),
            ),
          ),
          
          const SizedBox(height: 30),

          // 3. Info & Salary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                  const Text("업계 신입 평균 연봉", style: TextStyle(color: Colors.grey)),
                  Text(data.avgSalary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
               ],
            ),
          ),
          const SizedBox(height: 40),

          // 4. Action
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            ),
            child: const Text("상세 리포트 확인하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  
  Widget _legendItem(Color color, String text, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 12, height: 12, 
          decoration: BoxDecoration(color: isDashed ? Colors.transparent : color, border: isDashed ? Border.all(color: color) : null, shape: BoxShape.circle)
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getStatusColor(VisaStatus status) {
    switch (status) {
      case VisaStatus.GREEN: return Colors.green;
      case VisaStatus.YELLOW: return Colors.orange;
      case VisaStatus.RED: return Colors.red;
    }
  }
  
  IconData _getStatusIcon(VisaStatus status) {
    switch (status) {
      case VisaStatus.GREEN: return Icons.check_circle;
      case VisaStatus.YELLOW: return Icons.warning;
      case VisaStatus.RED: return Icons.cancel;
    }
  }

  String _getStatusMessage(VisaStatus status) {
    switch (status) {
      case VisaStatus.GREEN: return "발급 가능성이 매우 높습니다!";
      case VisaStatus.YELLOW: return "일부 요건 보완이 필요합니다.";
      case VisaStatus.RED: return "현재로서는 발급이 어렵습니다.";
    }
  }
}

// ---------------------------------------------------------------------------
// 5-Axis Benchmarking Radar Chart
// ---------------------------------------------------------------------------
class RadarChartPainter extends CustomPainter {
  final Map<String, int> myScores;
  final Map<String, int> avgScores;

  RadarChartPainter(this.myScores, this.avgScores);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY) * 0.8;
    
    // Grid
    final paintGrid = Paint()..color = Colors.grey[200]!..style = PaintingStyle.stroke;
    final keys = myScores.keys.toList();
    final angleStep = (2 * pi) / keys.length;

    for (int i = 1; i <= 5; i++) {
        double r = radius * (i / 5);
        _drawPolygon(canvas, centerX, centerY, r, keys.length, angleStep, paintGrid);
    }
    
    // Axes
    for(int j=0; j<keys.length; j++) {
        double angle = j * angleStep - (pi / 2);
        canvas.drawLine(Offset(centerX, centerY), Offset(centerX + radius * cos(angle), centerY + radius * sin(angle)), paintGrid);
    }

    // Average Score (Lavender, Solid Border)
    final paintAvg = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.2) // Lavender Fill
      ..style = PaintingStyle.fill;
    
    final paintAvgBorder = Paint()
      ..color = Colors.purple // Solid Purple Border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _drawDataPolygon(canvas, centerX, centerY, radius, angleStep, keys, avgScores, paintAvg, borderPaint: paintAvgBorder);

    // My Score (Blue Fill)
    final paintMy = Paint()..color = Colors.blue.withOpacity(0.4)..style = PaintingStyle.fill;
    final paintMyBorder = Paint()..color = Colors.blue..style = PaintingStyle.stroke..strokeWidth = 2;
    _drawDataPolygon(canvas, centerX, centerY, radius, angleStep, keys, myScores, paintMy, borderPaint: paintMyBorder);
    
    // Labels
    _drawLabels(canvas, centerX, centerY, radius, angleStep, keys);
  }

  void _drawPolygon(Canvas canvas, double cx, double cy, double r, int sides, double step, Paint paint) {
    Path path = Path();
    for (int i = 0; i < sides; i++) {
      double angle = i * step - (pi / 2);
      double x = cx + r * cos(angle);
      double y = cy + r * sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDataPolygon(Canvas canvas, double cx, double cy, double r, double step, List<String> keys, Map<String, int> scores, Paint paint, {bool fill = true, Paint? borderPaint}) {
    Path path = Path();
    for (int i = 0; i < keys.length; i++) {
      double val = (scores[keys[i]] ?? 0) / 100.0;
      double angle = i * step - (pi / 2);
      double x = cx + r * val * cos(angle);
      double y = cy + r * val * sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint); // Fill
    if (borderPaint != null) canvas.drawPath(path, borderPaint); // Border
  }
  
  void _drawLabels(Canvas canvas, double cx, double cy, double r, double step, List<String> keys) {
     final tp = TextPainter(textDirection: TextDirection.ltr);
     for (int i = 0; i < keys.length; i++) {
        double angle = i * step - (pi / 2);
        double x = cx + (r + 20) * cos(angle);
        double y = cy + (r + 20) * sin(angle);
        tp.text = TextSpan(text: keys[i], style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold));
        tp.layout();
        tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
     }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
