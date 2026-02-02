import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shop_provider.dart';
import '../../models/shop_model.dart';

class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final myInventory = shopState.inventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('보관함'),
        centerTitle: true,
      ),
      body: myInventory.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: myInventory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = myInventory[index];
                return _buildInventoryItem(context, item);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            '보관함이 비어있어요 텅~ 🗑️',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to Shop
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("쇼핑하러 가기", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(BuildContext context, Shop item) { // Changed ShopProduct to Shop
    final imgUrl = item.imageUrl ?? 'assets/images/placeholder.png'; // Null check
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
             child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imgUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image)),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          // Use Button
          ElevatedButton(
            onPressed: () => _showBarcodeDialog(context, item),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF8B5CF6),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF8B5CF6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text("사용하기"),
          ),
        ],
      ),
    );
  }

  void _showBarcodeDialog(BuildContext context, Shop item) { // Changed ShopProduct to Shop
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Dummy Barcode
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: List.generate(30, (index) {
                     // Generate random widths for barcode look
                     return Container(
                       width: 2 + (index % 3) * 2.0,
                       height: 60,
                       color: Colors.black,
                     );
                   }),
                ),
              ),
              const SizedBox(height: 10),
              const Text("1234 5678 9012", style: TextStyle(letterSpacing: 4, fontSize: 12)),
              const SizedBox(height: 20),
              const Text(
                "직원에게 보여주세요",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }
}
