import 'package:edu_admin/feature/parent_screen/view/addparent_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/parent_screen/view/widgets/parentcard_widget.dart';
import 'package:flutter/material.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Parents",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Family contact directory",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorSystem.muted,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ColorSystem.light,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: ColorSystem.primary,
                    ),
                  ),
                ],
              ),
            ),

            // search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorSystem.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search parents",
                    hintStyle: TextStyle(
                      color: ColorSystem.muted,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorSystem.muted,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: ColorSystem.muted,
                        size: 20,
                      ),
                      onPressed: () {
                        // Open filter menu
                      },
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
                  onChanged: (value) {
                    // Search parent
                  },
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                children: [
                  parentCard(context, "Chan Sophea", "P003", 1, "Active"),
                  parentCard(context, "Robert Carter", "P004", 2, "Active"),
                  parentCard(context, "Maya Wilson", "P005", 1, "Active"),
                  parentCard(context, "Daniel Smith", "P006", 2, "Active"),
                  parentCard(context, "Ana Davis", "P007", 1, "Active"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: ColorSystem.primary.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: ColorSystem.primary,
            foregroundColor: ColorSystem.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.add_rounded, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddparentScreen()),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
