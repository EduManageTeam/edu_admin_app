import 'package:flutter/material.dart';

// Color palette matching the design
const Color _primaryColor = Color(0xFFB4232D);
const Color _primaryLight = Color(0xFFFCECEF);
const Color _inkColor = Color(0xFF1D2939);
const Color _mutedColor = Color(0xFF667085);
const Color _cardBorderColor = Color(0xFFF2F4F7);

class _UserRoleItem {
  final String initial;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;

  const _UserRoleItem({
    required this.initial,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
  });
}

class UserAccessScreen extends StatefulWidget {
  const UserAccessScreen({super.key});

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<_UserRoleItem> _roles = const [
    _UserRoleItem(
      initial: 'C',
      title: 'CEO',
      subtitle: 'Executive leadership',
      badgeText: 'Read-mostly',
      badgeBg: Color(0xFFEEF4FF),
      badgeTextColor: Color(0xFF3538CD),
    ),
    _UserRoleItem(
      initial: 'A',
      title: 'Admin',
      subtitle: '4 administrators',
      badgeText: 'Full',
      badgeBg: Color(0xFFFCECEF),
      badgeTextColor: Color(0xFFB4232D),
    ),
    _UserRoleItem(
      initial: 'T',
      title: 'Teacher',
      subtitle: '32 teacher accounts',
      badgeText: 'Teaching',
      badgeBg: Color(0xFFEFF8FF),
      badgeTextColor: Color(0xFF175CD3),
    ),
    _UserRoleItem(
      initial: 'P',
      title: 'Parent',
      subtitle: '256 parent accounts',
      badgeText: 'View',
      badgeBg: Color(0xFFEFF8FF),
      badgeTextColor: Color(0xFF175CD3),
    ),
    _UserRoleItem(
      initial: 'R',
      title: 'Reset requests',
      subtitle: '5 pending actions',
      badgeText: 'Review',
      badgeBg: Color(0xFFFEF6EE),
      badgeTextColor: Color(0xFFB54708),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // Top bar: back button + tag + right avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: _cardBorderColor),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 13,
                              color: _inkColor,
                            ),
                          ),
                        ),
                        const Text(
                          'EDUSCHOOL · ADMIN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: _primaryColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: _primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title and Subtitle
                const Text(
                  'Users & Access',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _inkColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Roles, security and permissions',
                  style: TextStyle(fontSize: 14, color: _mutedColor),
                ),
                const SizedBox(height: 20),

                // Red Banner Card: Total System Directory
                _buildTotalDirectoryCard(),
                const SizedBox(height: 18),

                // Tab Switcher: Users / Roles
                _buildTabSwitcher(),
                const SizedBox(height: 16),

                // Search field
                _buildSearchBar(),
                const SizedBox(height: 16),

                // Role cards list
                ..._roles.map(_buildRoleCard),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDirectoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total System Directory',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SECURE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF027A48),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '817',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Single-sign-on & portal credentials',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? const Color(0xFF101828)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Users',
                    style: TextStyle(
                      color: _selectedTabIndex == 0
                          ? Colors.white
                          : _mutedColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color(0xFF101828)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Roles',
                    style: TextStyle(
                      color: _selectedTabIndex == 1
                          ? Colors.white
                          : _mutedColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search identity or User ID',
          hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13.5),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF98A2B3),
            size: 20,
          ),
          suffixIcon: Icon(
            Icons.tune_rounded,
            color: Color(0xFF98A2B3),
            size: 18,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRoleCard(_UserRoleItem item) {
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
          onTap: () {},
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.badgeText,
                    style: TextStyle(
                      color: item.badgeTextColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
