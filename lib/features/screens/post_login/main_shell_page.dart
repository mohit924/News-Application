import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/constants/app_colors.dart';

class MainShellPage extends StatefulWidget {
  final Widget child;
  const MainShellPage({super.key, required this.child});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  final tabs = ['/app/home', '/app/search', '/app/favourite'];

  void _onTap(int i) {
    setState(() => _index = i);
    context.go(tabs[i]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isActive: _index == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search_rounded,
                  label: 'Search',
                  isActive: _index == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  icon: Icons.favorite_outline_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: 'Saved',
                  isActive: _index == 2,
                  onTap: () => _onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
