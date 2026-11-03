import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/provider/school_provider.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectsScreen extends ConsumerStatefulWidget {
  final bool showBack;

  const SubjectsScreen({super.key, this.showBack = false});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsResponseProvider);

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: 'Subjects',
            subtitle: 'School-wide subject catalog',
            showBack: widget.showBack,
          ),
          Expanded(
            child: RefreshIndicator(
              color: ColorSystem.primary,
              onRefresh: () async {
                ref.invalidate(subjectsResponseProvider);
                await ref.read(subjectsResponseProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search subjects',
                      hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: ColorSystem.muted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              color: ColorSystem.muted,
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : Icon(Icons.menu_book_outlined, color: ColorSystem.muted),
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
                  ),
                  const SizedBox(height: 16),
                  subjectsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 40, color: ColorSystem.danger),
                          const SizedBox(height: 8),
                          Text(
                            error.toString().replaceFirst('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ColorSystem.muted, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () => ref.invalidate(subjectsResponseProvider),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Try again'),
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
                    ),
                    data: (response) {
                      final filtered = _searchQuery.isEmpty
                          ? response.data
                          : response.data.where((s) {
                              final nameMatch = s.name.toLowerCase().contains(_searchQuery);
                              final descMatch = (s.description ?? '').toLowerCase().contains(_searchQuery);
                              return nameMatch || descMatch;
                            }).toList();

                      if (filtered.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              _searchQuery.isNotEmpty
                                  ? 'No subjects matching "$_searchQuery"'
                                  : 'No subjects registered yet.',
                              style: TextStyle(color: ColorSystem.muted, fontSize: 14),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: filtered.map((s) {
                          return InfoTile(
                            item: InfoItem(
                              title: s.name,
                              subtitle: s.description != null && s.description!.trim().isNotEmpty
                                  ? s.description!
                                  : 'Subject ID: ${s.id}',
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
