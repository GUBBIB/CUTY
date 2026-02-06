import '../models/community_model.dart'; // For BoardType

class AdItem {
  final String imageUrl;
  final String linkUrl;
  final String title;
  final String sponsorName;

  const AdItem({
    required this.imageUrl,
    required this.linkUrl,
    required this.title,
    required this.sponsorName,
  });

  // Targeted Ads Logic
  static List<AdItem> getAds(BoardType? boardType) {
    if (boardType == BoardType.info) {
      // Info Board: Education, Visa, Moving (Serious/Utility)
      return [
        const AdItem(
          imageUrl: 'assets/images/ad_banner_2.png',
          linkUrl: 'https://example.com/promotion2',
          title: '토픽(TOPIK) 인강 50% 할인 쿠폰 🎓',
          sponsorName: 'Hackers Edu',
        ),
        const AdItem(
            imageUrl: 'assets/images/ad_banner_3.png',
            linkUrl: 'https://example.com/promotion3',
            title: '귀국 이사, 최저가 견적 비교 ✈️',
            sponsorName: 'Hanjin Express',
        ),
      ];
    } else if (boardType == BoardType.free) {
      // Free Board: Lifestyle, Housing, Phone (General/Fun)
      return [
        const AdItem(
          imageUrl: 'assets/images/ad_banner_1.png',
          linkUrl: 'https://example.com/promotion1',
          title: '유학생 전용 5G 요금제 특가! 📱',
          sponsorName: 'KT Global',
        ),
        const AdItem(
            imageUrl: 'assets/images/ad_banner_4.png',
            linkUrl: 'https://example.com/promotion4',
            title: '신촌/홍대 자취방 구하기 🏠',
            sponsorName: 'Zigbang',
        ),
      ];
    } else if (boardType == BoardType.market) {      
       // Used Market: Logistics, Delivery
       return [
          const AdItem(
            imageUrl: 'assets/images/ad_banner_3.png',
            linkUrl: 'https://example.com/promotion3',
            title: '중고거래 택배비 500원 할인! 📦',
            sponsorName: 'CU Safety Delivery',
          ),
       ];
    }

    // Default/Mixed
    return dummyAds;
  }


  // Fallback / All
  static List<AdItem> get dummyAds => [
    const AdItem(
      imageUrl: 'assets/images/ad_banner_1.png', // Placeholder asset
      linkUrl: 'https://example.com/promotion1',
      title: '유학생 전용 5G 요금제 특가! 📱',
      sponsorName: 'KT Global',
    ),
    const AdItem(
      imageUrl: 'assets/images/ad_banner_2.png',
      linkUrl: 'https://example.com/promotion2',
      title: '토픽(TOPIK) 인강 50% 할인 쿠폰 🎓',
      sponsorName: 'Hackers Edu',
    ),
    const AdItem(
      imageUrl: 'assets/images/ad_banner_3.png',
      linkUrl: 'https://example.com/promotion3',
      title: '귀국 이사, 최저가 견적 비교 ✈️',
      sponsorName: 'Hanjin Express',
    ),
     const AdItem(
      imageUrl: 'assets/images/ad_banner_4.png',
      linkUrl: 'https://example.com/promotion4',
      title: '신촌/홍대 자취방 구하기 🏠',
      sponsorName: 'Zigbang',
    ),
  ];
}
