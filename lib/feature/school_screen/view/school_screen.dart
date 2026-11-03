import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/subject_model.dart';
import 'package:edu_admin/feature/school_screen/provider/school_provider.dart';
import 'package:edu_admin/feature/school_screen/view/class_detail_screen.dart';
import 'package:edu_admin/feature/school_screen/widget/class_card.dart';
import 'package:edu_admin/feature/school_screen/widget/summary_card.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolScreen extends ConsumerStatefulWidget {
  const SchoolScreen({super.key});

  @override
  ConsumerState<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends ConsumerState<SchoolScreen> {
  // 0 = Classes tab, 1 = Subjects tab
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openClassDetail(ClassModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClassDetailScreen(item: item)),
    );
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(classesResponseProvider);
    ref.invalidate(subjectsResponseProvider);
    await Future.wait([
      ref.read(classesResponseProvider.future),
      ref.read(subjectsResponseProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(classesResponseProvider);
    final subjectsAsync = ref.watch(subjectsResponseProvider);
    final filteredClassesAsync = ref.watch(filteredClassesProvider);
    final filteredSubjectsAsync = ref.watch(filteredSubjectsProvider);
    final searchQuery = ref.watch(classSearchProvider);

    final totalClasses = classesAsync.asData?.value.meta.total;
    final totalSubjects = subjectsAsync.asData?.value.meta.total;

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: RefreshIndicator(
          color: ColorSystem.primary,
          onRefresh: _handleRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              SummaryCard(
                term: 'Academic Term —',
                roomsOpen: '—',
                totalClasses: totalClasses,
                subjects: totalSubjects,
                unassigned: '—',
              ),
              const SizedBox(height: 20),
              _buildTabs(),
              const SizedBox(height: 16),
              _buildSearchBar(searchQuery),
              const SizedBox(height: 16),
              if (_selectedTab == 0)
                ..._buildClassesTabContent(filteredClassesAsync, searchQuery)
              else
                ..._buildSubjectsTabContent(filteredSubjectsAsync, searchQuery),
            ],
          ),
        ),
      ),
    );
  }

  // Header: label, title, subtitle on the left, avatar on the right
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

  // Search bar connected to Riverpod search provider
  Widget _buildSearchBar(String query) {
    final hint = _selectedTab == 0
        ? 'Search class, room or teacher'
        : 'Search subjects';

    return TextField(
      controller: _searchController,
      onChanged: (value) {
        ref.read(classSearchProvider.notifier).state = value;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: ColorSystem.muted),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                color: ColorSystem.muted,
                onPressed: () {
                  _searchController.clear();
                  ref.read(classSearchProvider.notifier).state = '';
                },
              )
            : Icon(Icons.tune, color: ColorSystem.muted),
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

  // Classes tab: Handles loading, error, empty, and data states
  List<Widget> _buildClassesTabContent(
    AsyncValue<List<ClassModel>> classesAsync,
    String query,
  ) {
    return classesAsync.when(
      loading: () => [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (error, _) => [
        _buildErrorBox(
          message: error.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(classesResponseProvider),
        ),
      ],
      data: (classes) {
        if (classes.isEmpty) {
          return [
            _buildEmptyBox(
              title: query.isNotEmpty
                  ? 'No classes matching "$query"'
                  : 'No classes found',
              subtitle: query.isNotEmpty
                  ? 'Try searching with a different name, room, or teacher.'
                  : 'No classes are currently registered in the system.',
            ),
          ];
        }

        return classes
            .map(
              (item) => ClassCard(
                item: item,
                onTap: () => _openClassDetail(item),
              ),
            )
            .toList();
      },
    );
  }

  // Subjects tab: Handles loading, error, empty, and data states
  List<Widget> _buildSubjectsTabContent(
    AsyncValue<List<SubjectModel>> subjectsAsync,
    String query,
  ) {
    return subjectsAsync.when(
      loading: () => [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (error, _) => [
        _buildErrorBox(
          message: error.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(subjectsResponseProvider),
        ),
      ],
      data: (subjects) {
        if (subjects.isEmpty) {
          return [
            _buildEmptyBox(
              title: query.isNotEmpty
                  ? 'No subjects matching "$query"'
                  : 'No subjects found',
              subtitle: query.isNotEmpty
                  ? 'Try searching with a different subject name.'
                  : 'No subjects are registered in the curriculum catalog.',
            ),
          ];
        }

        return subjects
            .map((subject) => _buildSubjectCard(subject))
            .toList();
      },
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    final letter = subject.name.isNotEmpty
        ? subject.name[0].toUpperCase()
        : 'S';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorSystem.border),
        boxShadow: [
          BoxShadow(
            color: ColorSystem.lnk.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSystem.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: ColorSystem.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subject.description != null &&
                          subject.description!.trim().isNotEmpty
                      ? subject.description!
                      : 'Subject ID: ${subject.id}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorSystem.border),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 44, color: ColorSystem.danger),
          const SizedBox(height: 10),
          Text(
            'Failed to load information',
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Try Again'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorSystem.primary,
              side: BorderSide(color: ColorSystem.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBox({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 44, color: ColorSystem.muted),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
