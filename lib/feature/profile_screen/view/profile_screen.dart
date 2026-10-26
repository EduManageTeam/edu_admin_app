import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _profileHeader('More', 'Account & teaching settings', () {}),
          SizedBox(height: 12),
          _profileCard(),
        ],
      ),
    );
  }

  Widget _profileHeader(String title, String subTitle, Function onTap) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                subTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          IconButton(onPressed: () => onTap, icon: Icon(Icons.notifications)),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(0, 2),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xffB4232D),
              child: Text(
                'SJ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Jonhson',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 14),
                Text(
                  'Mathematics Teacher',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 14),
                Text(
                  'ID TEACHER 12',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xffB4232D),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
