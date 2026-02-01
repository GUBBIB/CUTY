import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shop_provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/point_provider.dart';
import 'widgets/shop_banner_carousel.dart';
import '../../widgets/shop/shop_list_item.dart';
import '../home/widgets/fortune_cookie_dialog.dart';
import 'shop_detail_screen.dart';
import 'storage_screen.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String _selectedCategory = '전체';
  
  final categories = [
    {'id': 'all', 'label': '전체', 'icon': Icons.grid_view_rounded},
    {'id': 'cafe', 'label': '카페', 'icon': Icons.coffee_rounded},
    {'id': 'store', 'label': '편의점', 'icon': Icons.store_mall_directory_rounded},
    {'id': 'voucher', 'label': '상품권', 'icon': Icons.confirmation_number_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    // Watch Providers
    final shopState = ref.watch(shopProvider);
    final pointState = ref.watch(pointProvider);

    // Filter Products
    final filteredProducts = _selectedCategory == '전체' 
        ? shopState.products 
        : shopState.products.where((p) {
            String catId = categories.firstWhere((c) => c['label'] == _selectedCategory)['id'] as String;
            return p.category == catId;
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: -5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
             final canPop = Navigator.canPop(context);
             if (canPop) {
               Navigator.pop(context);
             } else {
               ref.read(bottomNavIndexProvider.notifier).state = 1; // 1 is Home
             }
          },
        ),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(text: 'CUTY ', style: TextStyle(color: Color(0xFF1A2B48))),
              TextSpan(text: 'SHOP', style: TextStyle(color: Color(0xFF8B5CF6))),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StorageScreen()),
              );
            },
          ),
          GestureDetector(
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('포인트 충전소로 이동합니다 (준비중)'))
               );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                   Image.asset(
                     'assets/images/coin_gold.png',
                     width: 16,
                     height: 16,
                     fit: BoxFit.contain,
                   ),
                  const SizedBox(width: 6),
                  Text(
                    '${pointState.totalBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} P',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: shopState.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Carousel Banner
                 const SliverToBoxAdapter(
                  child: ShopBannerCarousel(),
                ),

                // Category Chips
                SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  elevation: 0,
                  toolbarHeight: 60,
                  flexibleSpace: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = _selectedCategory == cat['label'];
                      
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat['label'] as String),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8B5CF6) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[200]!,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ] : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                size: 16,
                                color: isSelected ? Colors.white : Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['label'] as String,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Product List (Horizontal Layout)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filteredProducts[index];
                        return ShopListItem(
                          product: product,
                          onTap: () {
                            // Navigate to Detail Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShopDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                ),
                
                // Bottom Safe Area
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                )
              ],
            ),
    );
  }
}
