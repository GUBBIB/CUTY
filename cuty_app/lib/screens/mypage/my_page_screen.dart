import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../l10n/gen/app_localizations.dart';
import '../wallet/my_point_screen.dart';
import '../spec/spec_wallet_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/point_provider.dart';
import '../schedule/schedule_screen.dart';
import '../../providers/schedule_provider.dart';
import '../../models/schedule_model.dart';
import 'profile_edit_screen.dart';
import 'my_community_activity_screen.dart';
import 'settings_screen.dart';
import '../shop/shop_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.dummy();

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // 1. Profile Header (Clickable)
                _ProfileHeader(user: user),
                const SizedBox(height: 24),

                // 2. Visa & Work Permit Dashboard
                _VisaDashboard(user: user),
                const SizedBox(height: 24),

                // 3. Weekly Schedule
                const _WeeklySchedule(),
                const SizedBox(height: 24),

                // 4. Menu List
                const _MenuList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _ProfileHeader extends ConsumerWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch PointProvider for real-time balance
    final pointState = ref.watch(pointProvider);
    final formattedPoints = NumberFormat('#,###').format(pointState.totalBalance);

    return Row(
      children: [
        // Clickable Profile Area
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
              );
            },
            behavior: HitTestBehavior.opaque, // Capture taps on empty space
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200], 
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipOval( 
                    child: Image.asset(
                      'assets/images/unknown_user.png',
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.edit_outlined, size: 16, color: Colors.grey[500]),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.university,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Points & Shop (Right Aligned)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPointScreen()),
                );
              },
              child: Text(
                '$formattedPoints P', 
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Navy
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5), // Indigo/Blue
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F51B5).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisaDashboard extends StatelessWidget {
  final User user;
  const _VisaDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    // Logic for Badge: If visa is "비자 정보 없음", show Grey "미연동" badge
    final isVisaEmpty = user.visaType == '비자 정보 없음';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF009688), // Teal
            Color(0xFF3F51B5), // Blue
            Color(0xFF9C27B0), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dashboardTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Card 1: Visa Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dashboardVisaStatus,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.visaType} | 만료: ${user.visaExpiry}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVisaEmpty ? Colors.grey[200] : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isVisaEmpty ? AppLocalizations.of(context)!.dashboardUnlinked : AppLocalizations.of(context)!.dashboardSafe,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isVisaEmpty ? Colors.grey[600] : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Card 2: Work Permit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dashboardWorkPermit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isVisaEmpty ? '- ~ -' : '${user.workPermitDate} | ${user.isWorkPermitApproved ? AppLocalizations.of(context)!.statusApproved : AppLocalizations.of(context)!.statusPending}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isVisaEmpty ? Colors.grey : Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isVisaEmpty ? Icons.access_time_rounded : Icons.check, // Empty state -> Clock icon
                    size: 16,
                    color: isVisaEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _WeeklySchedule extends ConsumerWidget {
  const _WeeklySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleNotifier = ref.read(scheduleProvider.notifier);
    // Watch provider to rebuild when schedule changes
    ref.watch(scheduleProvider); 

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.scheduleTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppLocalizations.of(context)!.btnEdit,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table Layout
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: [
              // Header Row
              const TableRow(
                children: [
                  Center(child: Text('Mon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  Center(child: Text('Tue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  Center(child: Text('Wed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  Center(child: Text('Thu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  Center(child: Text('Fri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  Center(child: Text('Sat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red))),
                  Center(child: Text('Sun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red))),
                ],
              ),
              const TableRow(children: [SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12), SizedBox(height: 12)]),
              // Row 1: Classes Chips
              TableRow(
                children: [
                  for (int i = 1; i <= 7; i++)
                    _buildDayCell(context, scheduleNotifier.getClassesForDay(i)), // Pass context
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildDayCell(BuildContext context, List<Schedule> classes) { 
    if (classes.isEmpty) {
      return const SizedBox(height: 30, child: Center(child: Icon(Icons.circle, size: 6, color: Colors.grey)));
    }
    
    // Check if there are mainly classes or alba (if implemented later). For now, just '수업' blue chip.
    // If multiple classes, just show one '수업' chip to indicate busy.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppLocalizations.of(context)!.labelClass, // Localized
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1565C0),
        ),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.folder_outlined, AppLocalizations.of(context)!.menuSpecWallet, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecWalletScreen()));
          }),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(context, Icons.chat_bubble_outline_rounded, AppLocalizations.of(context)!.menuCommunityActivity, () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCommunityActivityScreen()));
          }),
           // Removed '개인 정보 관리' as it's moved to Profile Header
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(context, Icons.settings_outlined, AppLocalizations.of(context)!.menuSettings, () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
