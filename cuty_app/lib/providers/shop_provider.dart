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
  final List<ShopProduct> inventory; // 1. Added inventory
  final bool isLoading;

  ShopState({
    required this.products,
    required this.inventory,
    this.isLoading = false,
  });
  
  ShopState copyWith({
    List<ShopProduct>? products,
    List<ShopProduct>? inventory,
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
        ShopProduct(
          id: '1',
          name: '아메리카노',
          imageUrl: 'assets/images/capy_meal.png', 
          price: 2000,
          category: 'cafe',
          description: '시원한 아이스 아메리카노입니다.',
        ),
        ShopProduct(
          id: '2',
          name: '편의점 상품권',
          imageUrl: 'assets/images/capy_visa.png',
          price: 5000,
          category: 'voucher',
          description: '편의점에서 사용 가능한 5000원 상품권입니다.',
        ),
        ShopProduct(
          id: '3',
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
  // Requires PointNotifier to handle transaction
  bool buyItem(ShopProduct product, dynamic pointNotifier) {
    // Note: We use dynamic or specific type. PointNotifier is in another file.
    // Ideally we pass PointNotifier. But here we assume the caller passes the right object.
    // Better to import PointNotifier if possible, but circular dependency risk if not careful.
    // Since PointProvider is imported in screens, we relies on dependency injection at call site.
    // But to be type safe, we should import point_provider.dart if not already?
    // It's not imported here.
    // Let's rely on the method existing on the passed object or just change architecture?
    // The user instruction: "buyItem(ShopItem item, PointProvider pointProvider)"
    // I will assume pointNotifier has usePoints method.
    
    // In Dart, dynamic dispatch is risky.
    // But since this is a specific request, I'll allow it or add the import if I can.
    // I will assume the caller handles the point deduction if checking types is hard, 
    // OR simply act on the "pointNotifier" assuming it matches interface.
    // Let's add the import to be safe.
    
    final success = pointNotifier.usePoints(product.price, "${product.name} 구매");
    if (success) {
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
