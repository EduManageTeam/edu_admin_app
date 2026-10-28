import 'package:flutter/material.dart';

import '../model/color_system.dart';

/// Shared bottom navigation bar (Home, Students, People, School, More).
/// Everyone in the team uses this one widget.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    _NavItem('Students', Icons.people_outline, Icons.people_alt_rounded),
    _NavItem('People', Icons.groups_outlined, Icons.groups_rounded),
    _NavItem(
      'School',
      Icons.account_balance_outlined,
      Icons.account_balance_rounded,
    ),
    _NavItem('More', Icons.more_horiz, Icons.more_horiz),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        border: Border(top: BorderSide(color: ColorSystem.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pink pill with a red border behind the active icon
                      Container(
                        width: 56,
                        height: 30,
                        decoration: BoxDecoration(
                          color: active
                              ? ColorSystem.light
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: active
                                ? ColorSystem.primary
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          active ? item.activeIcon : item.icon,
                          size: 22,
                          color: active
                              ? ColorSystem.primary
                              : ColorSystem.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: active
                              ? ColorSystem.primary
                              : ColorSystem.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem(this.label, this.icon, this.activeIcon);
}
