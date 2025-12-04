import 'package:flutter/material.dart';

class CustomHeaderBar extends StatelessWidget {
  final int selectedIndex;
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackPressed;

  const CustomHeaderBar({
    Key? key,
    required this.selectedIndex,
    required this.title,
    this.onMenuPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8ED6FF), Color(0xFFB1E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: onMenuPressed,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTab(context, 'Water Quality', 0),
                  _buildTab(context, 'Dashboard', 1),
                  _buildTab(context, 'See Usage', 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(left: selectedIndex * 120.0),
                    height: 2,
                    width: 100,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (selectedIndex == index) return;
        // Centralized routing logic
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/quality');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/usage');
            break;
        }
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
