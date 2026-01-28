import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

class JobCategoryTab extends StatefulWidget {
  const JobCategoryTab({super.key});

  @override
  State<JobCategoryTab> createState() => _JobCategoryTabState();
}

class _JobCategoryTabState extends State<JobCategoryTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: [
          _buildTab('알바', '(Part-Time)', 0),
          _buildTab('취업', '(Career)', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String subtitle, int index) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppTheme.darkGreen : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppTheme.darkGreen : Colors.grey[400],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppTheme.darkGreen : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
