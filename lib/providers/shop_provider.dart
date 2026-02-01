import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String description;

  ShopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
  });
}

class ShopState {
  final List<ShopProduct> products;
  final bool isLoading;

  ShopState({
    required this.products,
    this.isLoading = false,
  });
}

class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(ShopState(products: [])) {
    _loadMockData();
  }

  void _loadMockData() {
    state = ShopState(
      products: [
        ShopProduct(
          id: '1',
          name: '아메리카노',
          imageUrl: 'assets/images/capy_meal.png', // Temporary: Use existing image
          price: 2000,
          category: 'cafe',
          description: '시원한 아이스 아메리카노입니다.',
        ),
        ShopProduct(
          id: '2',
          name: '편의점 상품권',
          imageUrl: 'assets/images/capy_visa.png', // Temporary: Use existing image
          price: 5000,
          category: 'voucher',
          description: '편의점에서 사용 가능한 5000원 상품권입니다.',
        ),
        ShopProduct(
          id: '3',
          name: '카페라떼',
          imageUrl: 'assets/images/item_fortune_cookie.png', // Temporary: Use existing image
          price: 3500,
          category: 'cafe',
          description: '부드러운 우유가 들어간 카페라떼입니다.',
        ),
      ],
      isLoading: false,
    );
  }
}

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});
