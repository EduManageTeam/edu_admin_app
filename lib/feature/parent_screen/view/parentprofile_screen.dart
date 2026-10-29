import 'package:edu_admin/feature/parent_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorSystem.light,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new, size: 18),
                    color: ColorSystem.lnk,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chan Sophea",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Parent · #P003",
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorSystem.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProfileCard(),
                    SizedBox(height: 16),
                    Text(
                      "Information",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ColorSystem.lnk,
                      ),
                    ),
                    SizedBox(height: 10),
                    _parentInfoCard("P", "Parent ID", "#P003"),
                    SizedBox(height: 6),
                    _parentInfoCard("P", "Phone", "096 234 5678"),
                    SizedBox(height: 6),
                    _parentInfoCard("E", "Email", "parent@school.edu"),
                    SizedBox(height: 6),
                    _parentInfoCard("C", "Children", "1 linked student"),
                    SizedBox(height: 6),
                    _parentInfoCard("A", "Address", "Phnom Penh"),
                    // SizedBox(height: 6),
                    // _parentInfoCard("S", "Status", "Active"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                // edit parent
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorSystem.primary,
                                foregroundColor: ColorSystem.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text("Edit"),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () {
                                // delete parent
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ColorSystem.surface,
                                foregroundColor: ColorSystem.primary,
                                side: BorderSide(color: ColorSystem.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Delete"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _parentInfoCard(String initial, String title, String value) {
    return Card(
      color: ColorSystem.surface,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorSystem.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorSystem.light,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            initial,
            style: TextStyle(
              color: ColorSystem.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorSystem.lnk,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 12, color: ColorSystem.muted),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.chevron_right, color: ColorSystem.muted, size: 20),
      ),
    );
  }
}
