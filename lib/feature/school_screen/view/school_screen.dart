import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/school_screen/widget/class_card.dart';
import 'package:edu_admin/feature/school_screen/widget/summary_card.dart';
import 'package:flutter/material.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  int _selectedTab = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
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
            if (_selectedTab == 0)
              ..._classes.map((item) => ClassCard(item: item))
            else
              _buildSubjectsPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  fontSize: 24,
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

  Widget _buildTabButton(String label, int index) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.primary),
        ),
      ),
    );
  }

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
