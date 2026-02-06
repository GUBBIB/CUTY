import '../models/community_model.dart';
// ignore_for_file: non_constant_identifier_names

final List<Post> allPosts = [
  // --- Popular / High Likes ---
  Post(
    id: 'p1',
    boardType: BoardType.info,
    title: 'D-2 비자 연장 후기 (하이코리아 방문 꿀팁)',
    content: '어제 출입국 관리 사무소 다녀왔는데 사람이 진짜 많더라고. \n서류 미리 안 챙겼으면 큰일 날 뻔 했어..\n\n1. 방문 예약 필수 (최소 2주 전)\n2. 통합신청서 미리 작성하기\n3. 잔고증명서 유효기간 확인\n\n다들 미리미리 준비해!',
    authorName: '비자마스터',
    authorSchool: '본부',
    authorNationality: 'VN',
    likeCount: 450,
    commentCount: 52,
    imageUrl: 'https://source.unsplash.com/random/800x600/?office,document',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Post(
    id: 'p2',
    boardType: BoardType.free,
    title: '한국인 친구 사귀는 법 현실 조언 좀...',
    content: '수업만 듣고 집에 가니까 친구 사귀기가 너무 힘들어 ㅠㅠ\n동아리 들어가면 좀 나을까? 한국어 아직 서툰데 받아줄지 모르겠네.\n다들 어떻게 친구 만들었어?',
    authorName: 'K-Dream',
    authorSchool: '경성대',
    authorNationality: 'CN',
    likeCount: 320,
    commentCount: 85,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Post(
    id: 'p3',
    boardType: BoardType.market,
    title: '[나눔] 귀국해서 전기장판, 밥솥 급처합니다 (상태 S급)',
    content: '본국으로 돌아가게 돼서 짐 정리해요.\n작년 겨울에 사서 깨끗하게 썼습니다.\n학교 정문이나 기숙사 앞에서 드릴게요! 쪽지 주세요.',
    authorName: '떠나는나그네',
    authorSchool: '부경대',
    authorNationality: 'JP',
    likeCount: 150,
    commentCount: 22,
    imageUrl: 'https://source.unsplash.com/random/800x600/?electricblanket,ricecooker',
    price: 0,
    status: '나눔',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),

  // --- Free Board ---
  Post(
    id: 'f1',
    boardType: BoardType.free,
    title: '편의점 알바 면접 봤는데 사장님이 사투리 써서 못 알아들었어 ㅠㅠ',
    content: '"마! 니 이거 할 줄 아나?" 하시는데 벙쪄서...\n결국 떨어졌어 ㅋㅋㅋ 사투리 공부도 따로 해야 하나 봐.',
    authorName: '알바구함',
    authorSchool: '부산대',
    authorNationality: 'UZ', // Uzbekistan
    likeCount: 45,
    commentCount: 12,
    createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Post(
    id: 'f2',
    boardType: BoardType.free,
    title: '이번 학기 팀플 조원들이 나한테만 쉬운 거 시키는데 기분 나빠해야 돼?',
    content: '배려해주는 건 알겠는데 발표는 아예 제외 시키더라...\n나도 한국어 연습하고 싶은데 뭔가 소외감 느껴.',
    authorName: '열정맨',
    authorSchool: '동아대',
    authorNationality: 'US',
    likeCount: 28,
    commentCount: 18,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  Post(
    id: 'f3',
    boardType: BoardType.free,
    title: '신촌 근처 월세 50/500이면 적당한 거야? (오피스텔)',
    content: '학교랑 10분 거리인데 방이 좀 좁아 보여서...\n보증금 1000까지는 가능한데 더 좋은 방 있을까?\n부동산 앱 추천 좀 해줘!',
    authorName: '집구하기힘듬',
    authorSchool: '연세대',
    authorNationality: 'FR', // France
    likeCount: 15,
    commentCount: 8,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Post(
    id: 'f4',
    boardType: BoardType.free,
    title: '한국 배달 음식 추천해줘! 매운 거 잘 못 먹어.',
    content: '맨날 치킨만 시켜 먹어서 질렸어.\n맵지 않고 맛있는 거 뭐 없어? 족발은 어때?',
    authorName: '맵찔이',
    authorSchool: '경희대',
    authorNationality: 'TH', // Thailand
    likeCount: 62,
    commentCount: 30,
    imageUrl: 'https://source.unsplash.com/random/800x600/?koreanfood,delivery',
    createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
  ),
  Post(
    id: 'f5',
    boardType: BoardType.free,
    title: '교수님이 "밥 한번 먹자"고 하신 거 언제 먹는 거야?',
    content: '지난주에 말씀하셨는데 연락이 없으셔...\n내가 먼저 연락드려야 예의 바른 거야? 한국 문화 너무 어려워.',
    authorName: '문화차이',
    authorSchool: '고려대',
    authorNationality: 'DE', // Germany
    likeCount: 105,
    commentCount: 45,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),

  // --- Question Board ---
  Post(
    id: 'q1',
    boardType: BoardType.question,
    title: '외국인 등록증 재발급 기간 얼마나 걸려?',
    content: '지갑을 잃어버려서 다시 만들어야 하는데...\n보통 신청하면 며칠 안에 나오나? 급해서 ㅠㅠ',
    authorName: '비자급함',
    authorSchool: '성균관대',
    authorNationality: 'CN',
    likeCount: 5,
    commentCount: 8,
    rewardPoints: 500, // Added Reward
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Post(
    id: 'q2',
    boardType: BoardType.question,
    title: '학교 근처 안과 추천 좀 (다래끼 남 ㅠㅠ)',
    content: '아침에 일어났는데 눈이 너무 부었어.\n외국인 보험 되는 곳으로 추천 부탁해!\n신촌 근처야.',
    authorName: '눈아파',
    authorSchool: '연세대',
    authorNationality: 'JP',
    likeCount: 2,
    commentCount: 3,
    rewardPoints: 100, // Added Reward
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Post(
    id: 'q3',
    boardType: BoardType.question,
    title: '교수님한테 메일 보낼 때 첫마디 뭐라고 해?',
    content: '성적 정정 때문에 메일 써야 하는데...\n"안녕하세요 교수님" 하고 바로 본론 말해도 돼?\n한국 예절 너무 어려워.',
    authorName: '메일초보',
    authorSchool: '한양대',
    authorNationality: 'US',
    likeCount: 12,
    commentCount: 15,
    rewardPoints: 1000, // High Reward
    createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
  ),
  Post(
    id: 'q4',
    boardType: BoardType.question,
    title: '한국 친구 집들이 선물 뭐 사가야 좋아?',
    content: '초대 받았는데 휴지? 세제? \n요즘 대학생들은 다른 거 좋아하나?\n예산은 3만원 정도야.',
    authorName: '선물고민',
    authorSchool: '중앙대',
    authorNationality: 'FR',
    likeCount: 8,
    commentCount: 6,
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),

  // --- Info Board ---
  Post(
    id: 'i1',
    boardType: BoardType.info,
    title: '토픽(TOPIK) 6급 한 달 만에 따는 공부법 공유함',
    content: '듣기랑 쓰기에 집중했어.\n특히 쓰기 54번 문제는 템플릿 외우는 게 최고야!\n내가 공부했던 자료들 사진으로 첨부할게.',
    authorName: '한국어고수',
    authorSchool: '서울대',
    authorNationality: 'CN',
    likeCount: 210,
    commentCount: 34,
    imageUrl: 'https://source.unsplash.com/random/800x600/?study,notebook',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Post(
    id: 'i2',
    boardType: BoardType.info,
    title: '외국인 유학생 장학금 리스트 정리 (2026년 1학기)',
    content: '1. GKS (정부초청)\n2. 교내 성적 우수\n3. 기업 후원 (OO그룹, XX재단)\n\n조건이랑 마감일 정리해뒀으니까 꼭 신청해!',
    authorName: '장학금사냥꾼',
    authorSchool: '한양대',
    authorNationality: 'MN', // Mongolia
    likeCount: 180,
    commentCount: 25,
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
  Post(
    id: 'i3',
    boardType: BoardType.info,
    title: '부산 지하철 정기권 끊는 법 (교통비 절약)',
    content: '학교 통학할 때 지하철만 타면 정기권이 훨씬 이득이야.\n역무실 가서 카드 사고 충전하면 됨.\n한 달에 60회 쓸 수 있어.',
    authorName: '뚜벅이',
    authorSchool: '부산대',
    authorNationality: 'ID', // Indonesia
    likeCount: 95,
    commentCount: 11,
    imageUrl: 'https://source.unsplash.com/random/800x600/?subway,ticket',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Post(
    id: 'i4',
    boardType: BoardType.info,
    title: '쓰레기 분리수거 헷갈리는 사람? 이거만 봐',
    content: '음식물 쓰레기랑 일반 쓰레기 구분하는 거 정리해봤어.\n계란 껍질은 일반 쓰레기인 거 알았어?\n벌금 내지 말고 조심하자!',
    authorName: '환경지킴이',
    authorSchool: '중앙대',
    authorNationality: 'SE', // Sweden
    likeCount: 55,
    commentCount: 6,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),

  // --- Market ---
  Post(
    id: 'm1',
    boardType: BoardType.market,
    title: '[판매] 아이패드 에어 5세대 팝니다. (수업 필기용으로만 씀)',
    content: '작년 3월 구매했고 찍힘이나 기스 전혀 없습니다.\n박스 풀셋이고 애플펜슬도 같이 드려요.\n직거래 선호합니다.',
    authorName: '사과농장',
    authorSchool: '성균관대',
    authorNationality: 'KR',
    likeCount: 12,
    commentCount: 3,
    imageUrl: 'https://source.unsplash.com/random/800x600/?ipad,tablet',
    price: 650000,
    status: '판매중',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Post(
    id: 'm2',
    boardType: BoardType.market,
    title: '[구매] 전공책 \'국제경영학\' 구해요.',
    content: '교수님이 제본 말고 원서 사라고 하셔서 ㅠㅠ\n필기 있어도 상관 없어요.\n싸게 파실 분 연락 주세요.',
    authorName: '책벌레',
    authorSchool: '경희대',
    authorNationality: 'MY', // Malaysia
    likeCount: 5,
    commentCount: 7,
    price: 0,
    status: '구하는중',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Post(
    id: 'm3',
    boardType: BoardType.market,
    title: '[판매] 겨울 롱패딩 팝니다 (노스페이스)',
    content: '한국 겨울 너무 추워서 샀는데 이제 귀국해서 팔아요.\n사이즈 100이고 드라이클리닝 완료했습니다.',
    authorName: '추워요',
    authorSchool: '한국외대',
    authorNationality: 'RU', // Russia
    likeCount: 30,
    commentCount: 12,
    imageUrl: 'https://source.unsplash.com/random/800x600/?wintercoat,padding',
    price: 150000,
    status: '판매중',
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Post(
    id: 'm4',
    boardType: BoardType.market,
    title: '[나눔] 자취방 그릇이랑 냄비 무료 나눔',
    content: '다이소에서 산 것들인데 쓰는데 문제 없어요.\n필요한 사람 그냥 가져가세요.',
    authorName: '기부천사',
    authorSchool: '홍익대',
    authorNationality: 'PH', // Philippines
    likeCount: 42,
    commentCount: 20,
    imageUrl: 'https://source.unsplash.com/random/800x600/?kitchenware,pot',
    price: 0,
    status: '완료',
    createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
];

// Helper Functions
List<Post> getPostsByBoardType(BoardType type) {
  return allPosts.where((post) => post.boardType == type).toList();
}

List<Post> getPopularPosts() {
  final sortedPosts = List<Post>.from(allPosts);
  sortedPosts.sort((a, b) => b.likeCount.compareTo(a.likeCount));
  return sortedPosts.take(5).toList();
}
