import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/provider/parent_provider.dart';
import 'package:edu_admin/feature/parent_screen/view/editparent_screen.dart';
import 'package:edu_admin/feature/parent_screen/view/widgets/parent_login_info.dart';
import 'package:edu_admin/feature/parent_screen/view/widgets/parent_profile_stat_card.dart';
import 'package:edu_admin/feature/teacher_screen/view/util/format_date.dart';
import 'package:edu_admin/feature/teacher_screen/view/util/phone_launcher.dart';
import 'package:edu_admin/feature/teacher_screen/view/util/string_util.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentProfileScreen extends ConsumerWidget {
  final ParentModel parent;
  const new({super.key, required this.parent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get parent details
    final parentData = ref.watch(parentDetailProvider(parent.id));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.appBG,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'Parent Profile',
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: ColorSystem.lnk),
            tooltip: 'More options',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: ColorSystem.danger,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Delete Parent',
                      style: TextStyle(
                        color: ColorSystem.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: parentData.when(
        data: (data) {
          final parData = data.parent;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
                  children: [
                    _profileHeader(data.parent),
                    SizedBox(height: 12),

                    // statistic
                    Row(
                      children: [
                        Expanded(
                          child: ParentProfileStatCard(
                            title: 'Children',
                            value: '${data.childrenCount}',
                            icon: Icons.people_outline_rounded,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ParentProfileStatCard(
                            title: 'Classes',
                            value: '${data.classesCount}',
                            icon: Icons.class_outlined,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18),
                    _personalInformation(data),

                    SizedBox(height: 18),
                    // Login info
                    ParentLoginInfo(loginId: data.loginId),
                    SizedBox(height: 18),
                    // children
                    _linkedChildren(data),
                  ],
                ),
              ),

              // bottom actions
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  decoration: BoxDecoration(
                    color: ColorSystem.surface,
                    border: Border(top: BorderSide(color: ColorSystem.border)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 14,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Contact
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Contact
                            try {
                              await PhoneLauncher.call(parData.phone);
                            } catch (error) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                  backgroundColor: ColorSystem.danger,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.phone_outlined, size: 18),
                          label: Text('Contact'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorSystem.primary,
                            backgroundColor: ColorSystem.surface,
                            side: BorderSide(color: ColorSystem.primary),
                            minimumSize: Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Edit Parent
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _openEditParent(context, data);
                          },
                          icon: Icon(Icons.edit_rounded, size: 18),
                          label: Text('Edit Parent'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSystem.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Error icon
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: ColorSystem.danger.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_off_rounded,
                      color: ColorSystem.danger,
                      size: 36,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Unable to load students',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Something went wrong while loading students.\n'
                    'Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorSystem.muted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Error details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColorSystem.danger.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: ColorSystem.danger.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      error.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorSystem.muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 22),

                  // Retry button
                  SizedBox(
                    width: 170,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(allParentDetailsProvider);
                      },
                      icon: Icon(Icons.refresh_rounded, size: 19),
                      label: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSystem.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        loading: () => Center(
          child: CircularProgressIndicator(color: ColorSystem.primary),
        ),
      ),
    );
  }

  // delete parent
  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ColorSystem.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.delete_outline_rounded,
            color: ColorSystem.danger,
            size: 36,
          ),
          title: Text('Delete Parent?', textAlign: TextAlign.center),
          content: const Text(
            'Are you sure you want to delete this parent? '
            'This action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.danger,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(parentProvider.notifier).deleteParent(parent.id);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('parent deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to delete parent: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Parent profile header
  Widget _profileHeader(ParentModel parent) {
    final bool isLinked = parent.childrenCount > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Parent avatar
          CircleAvatar(
            radius: 35,
            backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
            child: Text(
              getInitials(parent.name),
              style: TextStyle(
                color: ColorSystem.primary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SizedBox(width: 13),

          // Parent information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Parent name
                Text(
                  parent.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4),

                // Parent database ID
                Text(
                  'Parent ID #${parent.id}',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),

                SizedBox(height: 7),

                // Assigned / Unassigned label
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLinked
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                      color: isLinked
                          ? ColorSystem.success
                          : ColorSystem.warning,
                      size: 12,
                    ),

                    SizedBox(width: 4),

                    Text(
                      isLinked ? 'Assigned' : 'Unassigned',
                      style: TextStyle(
                        color: isLinked
                            ? ColorSystem.success
                            : ColorSystem.warning,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Personal information
  Widget _personalInformation(ParentDetailModel detail) {
    final parent = detail.parent;

    return Column(
      children: [
        ProfileSectionTitle(
          title: 'Personal Information',
          icon: Icons.person_rounded,
        ),
        SizedBox(height: 9),
        Container(
          decoration: cardDecoration(),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.wc_rounded,
                label: 'Gender',
                value: parent.gender,
              ),
              divider(),
              InfoRow(
                icon: Icons.phone_rounded,
                label: 'Phone',
                value: parent.phone.isEmpty ? 'Not provided' : parent.phone,
              ),
              divider(),
              InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: parent.email?.isNotEmpty == true
                    ? parent.email!
                    : 'Not provided',
              ),
              divider(),
              InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: parent.address.isEmpty ? 'Not provided' : parent.address,
              ),
              divider(),
              InfoRow(
                icon: Icons.calendar_month_outlined,
                label: 'Joined',
                value: formatDate(detail.joinedAt),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Linked children
  Widget _linkedChildren(ParentDetailModel detail) {
    final children = detail.children;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionTitle(
          title: 'Linked Children',
          icon: Icons.family_restroom_rounded,
          trailing: '${detail.childrenCount} Children',
        ),

        SizedBox(height: 9),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: cardDecoration(),
          child: children.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No linked children',
                      style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int index = 0; index < children.length; index++) ...[
                      _childRow(children[index]),

                      if (index < children.length - 1) divider(),
                    ],
                  ],
                ),
        ),

        SizedBox(height: 12),
      ],
    );
  }

  // Linked child row
  Widget _childRow(ParentChildModel child) {
    final studentClass = child.studentClass;

    final classInfo = studentClass == null
        ? 'No class assigned'
        : '${studentClass.grade} • '
              '${studentClass.name} • Room ${studentClass.room}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
            child: Text(
              getInitials(child.name),
              style: TextStyle(
                color: ColorSystem.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  classInfo,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Edit teacher
  Future<void> _openEditParent(
    BuildContext context,
    ParentDetailModel detail,
  ) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditParentScreen(
          parent: detail.parent,
          loginId: detail.loginId,
          joined: formatDate(detail.joinedAt),
          linkedChildren: detail.children,
        ),
      ),
    );
  }
}
