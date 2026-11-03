import 'package:flutter/cupertino.dart';

Widget statItem({
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
        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      ),

      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
