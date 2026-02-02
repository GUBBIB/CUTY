import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shop_model.dart';
// Note: PointNotifier import would be ideal but avoiding circular deps if point_provider imports shop_provider.
// Assuming dynamic dispatch for now as requested or purely interface based. 
// Ideally we should import point_provider.dart if point_provider doesn't import shop_provider.
// Checking file usage... MyPage imports both.
// I will keep it dynamic for flexibility or import if I knew point_provider path exactly (I do).
import 'point_provider.dart';

class ShopState {
  final List<Shop> products;
  final List<Shop> inventory;
  final bool isLoading;

  ShopState({
    required this.products,
    required this.inventory,
    this.isLoading = false,
  });
  
  ShopState copyWith({
    List<Shop>? products,
    List<Shop>? inventory,
    bool? isLoading,
  }) {
    return ShopState(
      products: products ?? this.products,
      inventory: inventory ?? this.inventory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(ShopState(products: [], inventory: [])) {
    _loadMockData();
  }

  void _loadMockData() {
    state = state.copyWith(
      products: [
        Shop(
          id: 1,
          name: '아메리카노',
          imageUrl: 'assets/images/capy_meal.png', 
          price: 2000,
          category: 'cafe',
          description: '시원한 아이스 아메리카노입니다.',
        ),
        Shop(
          id: 2,
          name: '편의점 상품권',
          imageUrl: 'assets/images/capy_visa.png',
          price: 5000,
          category: 'voucher',
          description: '편의점에서 사용 가능한 5000원 상품권입니다.',
        ),
        Shop(
          id: 3,
          name: '카페라떼',
          imageUrl: 'assets/images/item_fortune_cookie.png',
          price: 3500,
          category: 'cafe',
          description: '부드러운 우유가 들어간 카페라떼입니다.',
        ),
      ],
      isLoading: false,
    );
  }

  // 2. Buy Item Logic
  // Using PointNotifier
  bool buyItem(Shop product, PointNotifier pointNotifier) {
    if (pointNotifier.usePoints(product.price, "${product.name} 구매")) {
      state = state.copyWith(
        inventory: [...state.inventory, product],
      );
      return true;
    }
    return false;
  }
}

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});
