import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/school_screen/widget/search_field.dart';
import 'package:flutter/material.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  static const List<InfoItem> _items = [
    InfoItem(title: 'Mathematics', subtitle: '4 classes · 2 teachers'),
    InfoItem(title: 'English', subtitle: '4 classes · 2 teachers'),
    InfoItem(title: 'Science', subtitle: '3 classes · 2 teachers'),
    InfoItem(title: 'Social Studies', subtitle: '3 classes · 2 teachers'),
    InfoItem(title: 'Art & Design', subtitle: '2 classes · 1 teacher'),
    InfoItem(title: 'Physical Education', subtitle: '2 classes · 1 teacher'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          const ScreenHeader(
            title: 'Subjects',
            subtitle: 'Subject catalog & assignments',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                const SearchField(
                  hint: 'Search subjects',
                  trailingIcon: Icons.menu,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 106,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSystem.primary,
                        foregroundColor: ColorSystem.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        '+ Add',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._items.map((item) => InfoTile(item: item)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
