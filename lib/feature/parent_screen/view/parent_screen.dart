import 'package:edu_admin/feature/parent_screen/provider/parent_provider.dart';
import 'package:edu_admin/feature/parent_screen/view/addparent_screen.dart';
import 'package:edu_admin/feature/parent_screen/view/widgets/parentcard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentScreen extends ConsumerWidget {
  const ParentScreen({super.key});

  // Clear filters
  void _clearFilters(WidgetRef ref) {
    ref.read(parentSearchProvider.notifier).state = '';
    ref.read(parentFilterProvider.notifier).state = 'all';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentAsync = ref.watch(parentProvider);
    final search = ref.watch(parentSearchProvider);
    final filter = ref.watch(parentFilterProvider);
    final stats = parentAsync.asData?.value.stats;
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Text(
                    'EDUSCHOOL • ADMIN',
                    style: TextStyle(
                      color: ColorSystem.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(49, 180, 179, 179),
                    child: Text(
                      'A',
                      style: TextStyle(color: ColorSystem.primary),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5),

              Text(
                'Parent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),

              Text(
                'Family contact directory',
                style: TextStyle(color: ColorSystem.muted),
              ),

              SizedBox(height: 12),

              // SEARCH
              TextField(
                maxLength: 100,
                onChanged: (value) {
                  ref.read(parentSearchProvider.notifier).state = value.trim();
                },
                decoration: InputDecoration(
                  hintText: 'Search parent name, ID or phone',
                  counterText: '',
                  hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 13),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorSystem.muted,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: ColorSystem.primary,
                      size: 21,
                    ),
                    tooltip: 'Filter parents',
                    onPressed: () => _showFilter(context, ref),
                  ),
                  filled: true,
                  fillColor: ColorSystem.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: ColorSystem.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: ColorSystem.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: ColorSystem.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // STATISTICS
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ColorSystem.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem(
                      label: 'Total Parents',
                      value: '${stats?.total ?? 0}',
                      color: ColorSystem.lnk,
                    ),
                    _statItem(
                      label: 'Assigned',
                      value: '${stats?.linked ?? 0}',
                      color: ColorSystem.success,
                    ),
                    _statItem(
                      label: 'Unassigned',
                      value: '${stats?.unlinked ?? 0}',
                      color: ColorSystem.danger,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // PARENT LIST
              Expanded(
                child: parentAsync.when(
                  skipLoadingOnRefresh: true,
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: ColorSystem.primary,
                    ),
                  ),
                  error: (error, stackTrace) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: ColorSystem.danger,
                            ),
                             SizedBox(height: 12),
                             Text('Failed to load parents'),
                             SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorSystem.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                ref.read(parentProvider.notifier).loading();
                              },
                              icon:  Icon(Icons.refresh),
                              label:  Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  data: (response) {
                    final parents = response.parents;

                    if (parents.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.family_restroom_outlined,
                                  color: Color(0xFFC45114),
                                  size: 48,
                                ),
                                 SizedBox(height: 12),
                                 Text(
                                  'No parents found',
                                  style: TextStyle(
                                    color: Color(0xFFC45114),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                 SizedBox(height: 8),
                                Text(
                                  search.isNotEmpty
                                      ? 'Try another name, ID or phone'
                                      : filter != 'all'
                                      ? 'No parents match the selected filter'
                                      : 'No parents have been added yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorSystem.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _clearFilters(ref);

                                    if (search.isEmpty && filter == 'all') {
                                      ref
                                          .read(parentProvider.notifier)
                                          .loading();
                                    }
                                  },
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Try Again'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: ColorSystem.primary,
                                    side: BorderSide(
                                      color: ColorSystem.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: ColorSystem.primary,
                      onRefresh: () =>
                          ref.read(parentProvider.notifier).loading(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 2,
                          top: 4,
                          bottom: 100,
                        ),
                        itemCount: parents.length,
                        itemBuilder: (context, index) {
                          final parent = parents[index];

                          return parentCard(context, parent);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ADD PARENT
      floatingActionButton: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorSystem.primary, const Color(0xFFD45468)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ColorSystem.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddparentScreen(),
                ),
              );

              // AddParentFormNotifier invalidates shared cache
              // after a successful create.
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  const Text(
                    'Add Parent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // statistic
  Widget _statItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Filter parents
  void _showFilter(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorSystem.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, child) {
            final selectedFilter = ref.watch(parentFilterProvider);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Parents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: ColorSystem.lnk,
                      ),
                    ),

                    SizedBox(height: 16),

                    _filterTile(
                      sheetContext,
                      ref,
                      title: 'All Parents',
                      value: 'all',
                      selected: selectedFilter,
                      icon: Icons.people_outline_rounded,
                      color: ColorSystem.primary,
                    ),

                    _filterTile(
                      sheetContext,
                      ref,
                      title: 'Assigned',
                      value: 'linked',
                      selected: selectedFilter,
                      icon: Icons.family_restroom_rounded,
                      color: ColorSystem.success,
                    ),

                    _filterTile(
                      sheetContext,
                      ref,
                      title: 'Unassigned',
                      value: 'unlinked',
                      selected: selectedFilter,
                      icon: Icons.person_outline_rounded,
                      color: ColorSystem.danger,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Filter tile
  Widget _filterTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String value,
    required String selected,
    required IconData icon,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: selected == value
          ? Icon(Icons.check, color: ColorSystem.primary)
          : null,
      onTap: () {
        ref.read(parentFilterProvider.notifier).state = value;
        Navigator.pop(context);
      },
    );
  }
}
