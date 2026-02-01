import 'package:flutter/material.dart';

class CareerJobDetailScreen extends StatelessWidget {
  // 실제로는 리스트에서 클릭한 공고 데이터를 받아와야 합니다.
  // 여기서는 '슈퍼 매칭(Case 1)' 데이터를 예시로 보여줍니다.
  final Map<String, dynamic> jobData = {
    "company": "한화오션 (거제사업장)",
    "title": "선박 제어 시스템 설계 엔지니어 (신입/경력)",
    "salary": "4,200만원",
    "location": "경남 거제시 (인구소멸지역)",
    "tags": [
      {"type": "E-7", "text": "E-7 | 전자공학 2351"},
      {"type": "F2R_C", "text": "F-2-R | 경남 거제"},
      {"type": "S", "text": "GNI 70%↑ 충족"},
    ]
  };

  CareerJobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. 투명 앱바 (이미지 강조)
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      // 2. 하단 고정 버튼 (신청하기)
      bottomNavigationBar: _buildBottomActionBar(context),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------
            // 3. 상단 헤더 이미지 (기업/직무 분위기)
            // -------------------------------------------------------
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[300], // 이미지 로딩 전 배경
                  child: Image.asset(
                    'assets/images/company_bg.png', // ★ 배경 이미지 에셋 필요 (없으면 색상박스로 대체됨)
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(color: const Color(0xFF283593)), // 이미지 없으면 딥 인디고 배경
                  ),
                ),
                // 그라데이션 오버레이 (텍스트 가독성)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // -------------------------------------------------------
            // 4. 메인 정보 컨테이너 (그림자 0.4 적용)
            // -------------------------------------------------------
            Transform.translate(
              offset: const Offset(0, -20), // 이미지 위로 살짝 겹치게
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4), // ★ 요청하신 그림자 농도 0.4
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 기업명 & 인증 배지
                    Row(
                      children: [
                        Text(
                          jobData['company'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, size: 16, color: Colors.blue),
                        const Text(" 법무부 인증기업", style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // 공고 제목
                    Text(
                      jobData['title'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 16),

                    // 비자 태그 리스트 (크게 배치)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (jobData['tags'] as List).map<Widget>((tag) => _buildDetailBadge(tag)).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 24),

                    // -------------------------------------------------------
                    // 5. 비자 적합성 보증 카드 (신뢰성 포인트!)
                    // -------------------------------------------------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FF), // 아주 연한 블루 배경
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE3F2FD)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, color: Colors.indigo, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "비자 발급 안전 공고",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "이 공고는 ${jobData['location']} 소재지이며, 연봉 ${jobData['salary']}으로 F-2-R 및 E-7 비자 발급 요건을 충족합니다.",
                                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // -------------------------------------------------------
                    // 6. 상세 정보 (탭 대신 깔끔한 섹션형)
                    // -------------------------------------------------------
                    _buildSectionTitle("근무 조건"),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.monetization_on_outlined, "연봉", "${jobData['salary']} (면접 후 협의 가능)"),
                    _buildInfoRow(Icons.location_on_outlined, "근무지", jobData['location']),
                    _buildInfoRow(Icons.access_time, "근무시간", "주 5일 (09:00 - 18:00)"),
                    
                    const SizedBox(height: 32),
                    _buildSectionTitle("담당 업무"),
                    const SizedBox(height: 12),
                    const Text(
                      "• 선박 전기/전자 시스템 설계 및 도면 작성\n• 전장품 사양 검토 및 기술 협의\n• 생산 설계 기술 지원 및 현장 대응\n• 해외 선주와의 커뮤니케이션 (영어 우대)",
                      style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle("자격 요건"),
                    const SizedBox(height: 12),
                    const Text(
                      "• 국내 대학 관련 학과(전기, 전자, 제어 등) 학사 이상\n• 한국어 능통자 (TOPIK 4급 이상 권장)\n• E-7 또는 F-2-R 비자 발급에 결격 사유가 없는 자",
                      style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
                    ),
                    
                    const SizedBox(height: 100), // 하단 버튼 공간 확보
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 고정 버튼 (지원하기)
  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // TODO: 지원 프로세스 시작
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF283593), // 딥 인디고 (신뢰감)
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            "비자 매칭 지원하기",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 섹션 타이틀
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  // 아이콘 + 텍스트 정보 행
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // 상세 페이지용 대형 배지 빌더
  Widget _buildDetailBadge(Map<String, dynamic> tag) {
    Color bgColor;
    Color textColor;
    
    switch (tag['type']) {
      case 'E-7':
        bgColor = Colors.deepPurple[50]!;
        textColor = Colors.deepPurple;
        break;
      case 'F2R_C':
      case 'F2R_U':
        bgColor = Colors.teal[50]!;
        textColor = Colors.teal[800]!;
        break;
      default: // Salary
        bgColor = Colors.orange[50]!;
        textColor = Colors.deepOrange[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag['type'] == 'S') Icon(Icons.check_circle, size: 14, color: textColor),
          if (tag['type'] == 'S') const SizedBox(width: 6),
          Text(tag['text'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
