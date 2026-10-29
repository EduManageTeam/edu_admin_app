import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/feature/school_screen/view/class_detail_screen.dart';
import 'package:edu_admin/feature/school_screen/widget/class_card.dart';
import 'package:edu_admin/feature/school_screen/widget/summary_card.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// StatefulWidget, because the screen changes when the user taps a tab.
class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  // 0 = Classes tab, 1 = Subjects tab
  int _selectedTab = 0;

  // Fake data for UI only. Later it will come from the backend / Riverpod.
  static const List<ClassItem> _classes = [
    ClassItem(
      name: 'Grade 1A',
      room: 'Room 204',
      teacher: 'Sarah Johnson',
      students: 28,
      capacity: 30,
    ),
    ClassItem(
      name: 'Grade 1B',
      room: 'Room 205',
      teacher: 'Daniel Lee',
      students: 26,
      capacity: 30,
    ),
    ClassItem(
      name: 'Grade 2A',
      room: 'Room 108',
      teacher: 'Emily Davis',
      students: 25,
      capacity: 30,
    ),
    ClassItem(
      name: 'Grade 2B',
      room: 'Room 110',
      teacher: 'James Wilson',
      students: 26,
      capacity: 30,
    ),
    ClassItem(
      name: 'Grade 3A',
      room: 'Room 301',
      teacher: 'Olivia Martin',
      students: 24,
      capacity: 30,
    ),
  ];

  // NAVIGATION: open the Class Detail screen for the tapped class.
  // Navigator.push puts a new screen on top of this one.
  // MaterialPageRoute = the normal slide animation of the platform.
  void _openClassDetail(ClassItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClassDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      // SafeArea keeps the content away from the notch and status bar.
      body: SafeArea(
        // ListView scrolls when the content is taller than the screen.
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            // const is valid here: all values are fixed numbers and text.
            const SummaryCard(
              term: 'Academic Term 2026-2027',
              roomsOpen: 2,
              activeClasses: 18,
              subjects: 8,
              unassigned: 2,
            ),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            // "..." (spread) puts every card directly into the list.
            if (_selectedTab == 0)
              ..._classes.map(
                (item) =>
                    ClassCard(item: item, onTap: () => _openClassDetail(item)),
              )
            else
              _buildSubjectsPlaceholder(),
          ],
        ),
      ),
    );
  }

  // Header: label, title, subtitle on the left, avatar on the right
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded takes the remaining width, so the avatar stays at the right.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EDUSCHOOL • ADMIN',
                style: TextStyle(
                  color: ColorSystem.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Classes & Curriculum',
                style: TextStyle(
                  color: ColorSystem.lnk,
                  fontSize: 24, // Page title / 24 Bold
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rooms, teachers and active rosters',
                style: TextStyle(color: ColorSystem.muted, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 18,
          backgroundColor: ColorSystem.light,
          child: Text(
            'A',
            style: TextStyle(
              color: ColorSystem.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // Tabs: Classes | Subjects
  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorSystem.border.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabButton('Classes', 0),
          _buildTabButton('Subjects', 1),
        ],
      ),
    );
  }

  // One tab button, written once and used twice (no copy-paste).
  Widget _buildTabButton(String label, int index) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        // setState tells Flutter: "something changed, redraw the screen".
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Selected tab = dark ink background + white text
            color: isSelected ? ColorSystem.lnk : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorSystem.surface : ColorSystem.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Search bar (UI only, it does not filter yet)
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search class, room or teacher',
        hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: ColorSystem.muted),
        suffixIcon: Icon(Icons.tune, color: ColorSystem.muted),
        filled: true,
        fillColor: ColorSystem.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        // Border when NOT focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.border),
        ),
        // Border when the user taps inside (brand red)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.primary),
        ),
      ),
    );
  }

  // Temporary content for the Subjects tab
  Widget _buildSubjectsPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          'Subjects list coming soon',
          style: TextStyle(color: ColorSystem.muted, fontSize: 14),
        ),
      ),
    );
  }
}
