import 'package:edu_admin/feature/profile_screen/view/user_access_screen.dart';
export 'package:edu_admin/feature/profile_screen/view/user_access_screen.dart';
import 'package:flutter/material.dart';

// Color palette matching the design
const Color _primaryColor = Color(0xFFB4232D);
const Color _primaryLight = Color(0xFFFCECEF);
const Color _inkColor = Color(0xFF1D2939);
const Color _mutedColor = Color(0xFF667085);
const Color _borderColor = Color(0xFFE4E7EC);
const Color _cardBorderColor = Color(0xFFF2F4F7);
const Color _chevronColor = Color(0xFF98A2B3);

enum ProfileRole { admin, teacher }

class _SettingItem {
  final String initial;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.initial,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class ProfileScreen extends StatefulWidget {
  final ProfileRole role;

  const ProfileScreen({super.key, this.role = ProfileRole.admin});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<_SettingItem> _getAdminSettings(BuildContext context) => [
    const _SettingItem(
      initial: 'N',
      title: 'Notifications',
      subtitle: 'Operational alerts and notices',
    ),
    _SettingItem(
      initial: 'U',
      title: 'User access',
      subtitle: 'Roles and locked accounts',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserAccessScreen(),
          ),
        );
      },
    ),
    const _SettingItem(
      initial: 'S',
      title: 'School settings',
      subtitle: 'Academic year and defaults',
    ),
    const _SettingItem(
      initial: 'S',
      title: 'Security',
      subtitle: 'Password and active sessions',
    ),
  ];

  // Teacher settings items
  final List<_SettingItem> _teacherSettings = const [
    _SettingItem(
      initial: 'P',
      title: 'Personal information',
      subtitle: 'Phone, email and address',
    ),
    _SettingItem(
      initial: 'C',
      title: 'Change password',
      subtitle: 'Update account password',
    ),
    _SettingItem(
      initial: 'N',
      title: 'Notification settings',
      subtitle: 'Class and school alerts',
    ),
    _SettingItem(
      initial: 'H',
      title: 'Help & support',
      subtitle: 'Contact administration',
    ),
  ];

  bool get _isAdmin => widget.role == ProfileRole.admin;

  @override
  Widget build(BuildContext context) {
    final settings = _isAdmin ? _getAdminSettings(context) : _teacherSettings;
    final sectionTitle = _isAdmin ? 'Management' : 'Account';
    final subtitle = _isAdmin
        ? 'Account, alerts and settings'
        : 'Account & teaching settings';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.18, 0.4],
            colors: [Color(0xFFFFF0F2), Color(0xFFFDF7F8), Color(0xFFF8F9FC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Top red accent bar
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),

                // Header section: More + Subtitle + Notification status dot
                _buildHeader(subtitle),
                const SizedBox(height: 20),

                // Profile card (System Admin / Teacher)
                _buildProfileCard(),
                const SizedBox(height: 28),

                // Section title (Management / Account)
                Text(
                  sectionTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _inkColor,
                  ),
                ),
                const SizedBox(height: 14),

                // Settings list tiles
                ...settings.map(_buildSettingTile),

                const SizedBox(height: 36),

                // Sign out button
                _buildSignOutButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'More',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _inkColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: _mutedColor),
            ),
          ],
        ),
        // Top-right status indicator badge
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: _primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final avatarText = _isAdmin ? 'AD' : 'SJ';
    final name = _isAdmin ? 'System Admin' : 'Sarah Johnson';
    final role = _isAdmin ? null : 'Mathematics Teacher';
    final idText = _isAdmin ? 'ID · ADMIN-001' : 'ID · TEACHER-002';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                avatarText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _inkColor,
                  ),
                ),
                if (role != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 13, color: _mutedColor),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  idText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(_SettingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: item.onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                // Rounded letter badge
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item.initial,
                      style: const TextStyle(
                        color: _primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: _inkColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _chevronColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showSignOutDialog();
          },
          child: const Center(
            child: Text(
              'Sign out',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _mutedColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic here
            },
            child: const Text(
              'Sign out',
              style: TextStyle(color: _primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
