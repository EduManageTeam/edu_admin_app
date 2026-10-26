import 'package:edu_admin/feature/student_screen/view/student_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}