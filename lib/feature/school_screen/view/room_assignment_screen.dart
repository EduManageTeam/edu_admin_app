import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class RoomAssignmentScreen extends StatelessWidget {
  final String className;
  final String? room;

  const RoomAssignmentScreen({
    super.key,
    required this.className,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    final hasRoom = room != null && room!.trim().isNotEmpty;
    final roomName = hasRoom ? room!.trim() : 'No room assigned';

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: 'Room Assignment',
            subtitle: className,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                if (hasRoom) ...[
                  _buildRoomCard(roomName),
                  const SizedBox(height: 24),
                  Text(
                    'Classroom Details',
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InfoTile(
                    item: InfoItem(
                      title: 'Class Assigned',
                      subtitle: className,
                    ),
                  ),
                  InfoTile(
                    item: InfoItem(
                      title: 'Room Identifier',
                      subtitle: roomName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColorSystem.light.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ColorSystem.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: ColorSystem.muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Note: Physical facility management, room capacities, and building schedules are managed at the facility level.',
                            style: TextStyle(
                              color: ColorSystem.muted,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  _buildUnassignedRoomState(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(String roomName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
        boxShadow: [
          BoxShadow(
            color: ColorSystem.lnk.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSystem.light,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.meeting_room_outlined,
              size: 38,
              color: ColorSystem.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            roomName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Assigned room for $className',
            style: TextStyle(color: ColorSystem.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildUnassignedRoomState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 56,
            color: ColorSystem.muted,
          ),
          const SizedBox(height: 16),
          Text(
            'No Room Assigned',
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There is no physical room currently assigned to $className.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorSystem.muted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

