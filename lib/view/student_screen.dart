import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Students',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Text('Directory & enrollment'),
                  ],
                ),
                CircleAvatar(child: Text('A')),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search name, id, class or parent',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
