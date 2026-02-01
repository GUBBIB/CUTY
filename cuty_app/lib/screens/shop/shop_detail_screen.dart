import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shop_provider.dart';
import '../../providers/point_provider.dart';

class ShopDetailScreen extends ConsumerWidget {
  final ShopProduct product;

  const ShopDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${product.price} P',
              style: const TextStyle(fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // Terms & Conditions
             Container(
               width: double.infinity,
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: Colors.grey[50],
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.grey[200]!),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: const [
                   Text("상품 유의사항", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                   SizedBox(height: 8),
                   Text("• 해당 상품이 매장에 없을 경우, 동일 가격 이상의 다른 상품으로 교환이 가능합니다. (차액 결제 필요)", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                   Text("• 본 쿠폰의 유효기간은 발급일로부터 60일입니다.", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                   Text("• 일부 특수 매장(백화점, 공항, 휴게소 등)에서는 사용이 제한될 수 있습니다.", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                   Text("• 포인트로 구매한 상품은 현금으로 환불되지 않으며, 구매 후 취소가 불가능합니다.", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                   Text("• 사용 시 직원에게 바코드를 제시해 주세요. (화면 밝기 최대 권장)", style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                 ],
               ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   final pointNotifier = ref.read(pointProvider.notifier);
                   final shopNotifier = ref.read(shopProvider.notifier);
                   
                   final success = shopNotifier.buyItem(product, pointNotifier);
                   
                   if (success) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('🎉 구매 성공! 보관함에 담겼어요.')),
                     );
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: const Text('🥲 포인트가 부족합니다.'),
                         backgroundColor: Colors.red[400],
                       ),
                     );
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('구매하기', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
