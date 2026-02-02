import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
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
            _buildTotalResultView(result),
            // View B: Job Details
            ...jobResultList.map((jobData) => _buildJobDetailView(context, jobData, result.solutionDocs)),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalResultView(DiagnosisResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Circle Progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200, height: 200,
                child: CircularProgressIndicator(
                  value: result.totalScore / 100,
                  strokeWidth: 20,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.indigo),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${result.totalScore}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const Text("점 / 100", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(result.totalTier, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          
          // Advice Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.2))
            ),
            child: Column(
              children: [
                const Text("💡 AI 컨설턴트 한마디", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 8),
                Text(result.tierDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Basic Competency Radar (Simply using primary job's common scores)
          if (result.primary != null) ...[
             const Text("기초 역량 분석", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             const SizedBox(height: 20),
             SizedBox(
               height: 250,
               width: double.infinity,
               child: CustomPaint(
                 painter: RadarChartPainter(
                    // Filter to 3 basic axes
                    Map.fromEntries(result.primary!.myScores.entries.where((e) => ["언어", "성실성", "한국이해"].contains(e.key))),
                    Map.fromEntries(result.primary!.avgScores.entries.where((e) => ["언어", "성실성", "한국이해"].contains(e.key))),
                 ),
               ),
             ),
          ]
        ],
      ),
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
