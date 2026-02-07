import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shop_provider.dart';
import '../../providers/nav_provider.dart';
import '../../providers/point_provider.dart';
import 'dart:async'; // For Timer
import '../../widgets/shop/shop_list_item.dart';
import 'shop_detail_screen.dart';
import 'storage_screen.dart';
import '../../l10n/gen/app_localizations.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String _selectedCategory = 'all'; // Changed default to ID 'all'
  
  // Moved inside build to access context, or just keep IDs and map labels in build
  final categories = [
    {'id': 'all', 'icon': Icons.grid_view_rounded},
    {'id': 'cafe', 'icon': Icons.coffee_rounded},
    {'id': 'store', 'icon': Icons.store_mall_directory_rounded},
    {'id': 'voucher', 'icon': Icons.confirmation_number_rounded},
  ];

  String _getCategoryLabel(BuildContext context, String id) {
    switch (id) {
      case 'all': return AppLocalizations.of(context)!.itemCategoryAll;
      case 'cafe': return AppLocalizations.of(context)!.itemCategoryCafe;
      case 'store': return AppLocalizations.of(context)!.itemCategoryStore;
      case 'voucher': return AppLocalizations.of(context)!.itemCategoryVoucher;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch Providers
    final shopState = ref.watch(shopProvider);
    final pointState = ref.watch(pointProvider);

    // Filter Products
    final filteredProducts = _selectedCategory == 'all' 
        ? shopState.products 
        : shopState.products.where((p) => p.category == _selectedCategory).toList();


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
                 SnackBar(content: Text(AppLocalizations.of(context)!.msgPointShopComingSoon))
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
                  child: _ShopBanner(),
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
                      final catId = cat['id'] as String;
                      final label = _getCategoryLabel(context, catId);
                      final isSelected = _selectedCategory == catId;
                      
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = catId),
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
                                label,
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

class _ShopBanner extends StatefulWidget {
  const _ShopBanner();

  @override
  State<_ShopBanner> createState() => _ShopBannerState();
}

class _ShopBannerState extends State<_ShopBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) { 
      if (_pageController.hasClients) {
         int nextPage = _pageController.page!.toInt() + 1;
         _pageController.animateToPage(
           nextPage,
           duration: const Duration(milliseconds: 500),
           curve: Curves.easeInOut,
         );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Moved banners inside build to access context
  List<Map<String, dynamic>> _getBanners(BuildContext context) {
    return [
      {
        'color': const Color(0xFFFCE4EC), // Pink.shade50
        'title': AppLocalizations.of(context)!.bannerAdPoint,
        'image': 'assets/images/capy_AD.png', 
        'tag': AppLocalizations.of(context)!.tagAd,
        'titleColor': const Color(0xFFE91E63), // Pink
        'tagColor': const Color(0xFFC2185B),
      },
      {
        'color': const Color(0xFFE8EAF6), // Indigo.shade50
        'title': AppLocalizations.of(context)!.bannerNewDiscount,
        'image': 'assets/images/capy_business.png',
        'tag': AppLocalizations.of(context)!.tagEvent,
        'titleColor': const Color(0xFF3F51B5), // Indigo
        'tagColor': const Color(0xFF303F9F),
      },
      {
        'color': const Color(0xFFE8F5E9), // Green.shade50
        'title': AppLocalizations.of(context)!.bannerInviteFriend,
        'image': 'assets/images/capy_friend.png', 
        'tag': AppLocalizations.of(context)!.tagInvite,
        'titleColor': const Color(0xFF2E7D32), // Green
        'tagColor': const Color(0xFF1B5E20),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final banners = _getBanners(context);

    return Container(
       height: 160,
       margin: const EdgeInsets.all(20),
       child: Stack(
         alignment: Alignment.center,
         children: [
           PageView.builder(
             controller: _pageController,
             onPageChanged: (index) {
               setState(() => _currentPage = index % banners.length);
             },
             itemBuilder: (context, index) {
               final banner = banners[index % banners.length];
               return Container(
                 margin: const EdgeInsets.symmetric(horizontal: 4), 
                 decoration: BoxDecoration(
                   color: banner['color'],
                   borderRadius: BorderRadius.circular(16),
                 ),
                 child: Stack(
                   children: [
                     // Text Content
                     Positioned(
                       top: 30,
                       left: 24,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             decoration: BoxDecoration(
                               color: (banner['tagColor'] as Color).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Text(
                               banner['tag'] as String,
                               style: TextStyle(
                                 fontSize: 10,
                                 fontWeight: FontWeight.bold,
                                 color: banner['tagColor'],
                               ),
                             ),
                           ),
                           const SizedBox(height: 12),
                           Text(
                             banner['title'] as String,
                             style: TextStyle(
                               fontSize: 20,
                               fontWeight: FontWeight.bold,
                               color: banner['titleColor'],
                               height: 1.3,
                             ),
                           ),
                         ],
                       ),
                     ),
                     // Image (Right)
                     Positioned(
                       right: 10,
                       bottom: 10,
                       width: 100,
                       height: 100,
                       child: Image.asset(
                         banner['image'] as String,
                         fit: BoxFit.contain,
                         errorBuilder: (context, error, stackTrace) {
                           return Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]);
                         },
                       ),
                     ),
                   ],
                 ),
               );
             },
           ),
           
           // Indicators
           Positioned(
             bottom: 16,
             left: 0,
             right: 0,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: List.generate(banners.length, (index) {
                 final isActive = _currentPage == index;
                 return AnimatedContainer(
                   duration: const Duration(milliseconds: 300),
                   margin: const EdgeInsets.symmetric(horizontal: 3),
                   width: isActive ? 16 : 6,
                   height: 6,
                   decoration: BoxDecoration(
                     color: isActive ? Colors.black87 : Colors.black12,
                     borderRadius: BorderRadius.circular(3),
                   ),
                 );
               }),
             ),
           ),

           // Left Arrow
           Positioned(
             left: 10,
             child: GestureDetector(
               onTap: () {
                 _pageController.previousPage(
                   duration: const Duration(milliseconds: 300),
                   curve: Curves.easeInOut,
                 );
               },
               child: Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.5),
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54),
               ),
             ),
           ),

           // Right Arrow
           Positioned(
             right: 10,
             child: GestureDetector(
               onTap: () {
                 _pageController.nextPage(
                   duration: const Duration(milliseconds: 300),
                   curve: Curves.easeInOut,
                 );
               },
               child: Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.5),
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
               ),
             ),
           ),
         ],
       ),
    );
  }
}
