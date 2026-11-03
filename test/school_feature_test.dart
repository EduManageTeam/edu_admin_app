import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/subject_model.dart';
import 'package:edu_admin/feature/school_screen/widget/class_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('School Feature - Production Grade Formatter Tests', () {
    test('formatGrade handles raw numbers, existing prefixes, and empty values', () {
      expect(formatGrade('1'), 'Grade 1');
      expect(formatGrade('Grade 2'), 'Grade 2');
      expect(formatGrade('grade 2B'), 'Grade 2B');
      expect(formatGrade('GRADE 3A'), 'Grade 3A');
      expect(formatGrade('Grade Grade 2'), 'Grade 2');
      expect(formatGrade(''), 'Grade —');
      expect(formatGrade('   '), 'Grade —');
      expect(formatGrade(null), 'Grade —');
      expect(formatGrade('Grade'), 'Grade —');
    });

    test('ClassModel.formattedGrade uses the shared production formatGrade logic', () {
      const modelNumeric = ClassModel(
        id: 1,
        name: 'Math 1A',
        grade: '1',
      );
      expect(modelNumeric.formattedGrade, 'Grade 1');

      const modelPrefixed = ClassModel(
        id: 2,
        name: 'Math 2A',
        grade: 'Grade 2',
      );
      expect(modelPrefixed.formattedGrade, 'Grade 2');

      const modelEmpty = ClassModel(
        id: 3,
        name: 'Art',
        grade: '',
      );
      expect(modelEmpty.formattedGrade, 'Grade —');
    });
  });

  group('School Feature - ClassCard Widget Tests', () {
    testWidgets('ClassCard renders "Grade 1" when grade is "1" and never duplicates prefix', (tester) async {
      const item = ClassModel(
        id: 1,
        name: 'Grade 1A',
        grade: '1',
        room: 'Room 204',
        teacher: ClassTeacherModel(
          id: 10,
          userId: 100,
          name: 'Sarah Johnson',
          status: 'active',
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClassCard(item: item),
          ),
        ),
      );

      expect(find.text('Grade 1A'), findsOneWidget);
      expect(find.text('Grade 1'), findsOneWidget);
      expect(find.textContaining('Grade Grade'), findsNothing);
    });

    testWidgets('ClassCard renders "Grade 2" when grade is "Grade 2" and never renders "Grade Grade 2"', (tester) async {
      const item = ClassModel(
        id: 2,
        name: 'Grade 2B',
        grade: 'Grade 2',
        room: 'Room 108',
        teacher: ClassTeacherModel(
          id: 11,
          userId: 101,
          name: 'Emily Davis',
          status: 'active',
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClassCard(item: item),
          ),
        ),
      );

      expect(find.text('Grade 2B'), findsOneWidget);
      expect(find.text('Grade 2'), findsOneWidget);
      expect(find.textContaining('Grade Grade'), findsNothing);
      expect(find.text('Grade Grade 2'), findsNothing);
    });

    testWidgets('ClassCard handles empty/whitespace grade with "Grade —" fallback', (tester) async {
      const item = ClassModel(
        id: 3,
        name: 'Kindergarten',
        grade: '   ',
        room: 'Room 101',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClassCard(item: item),
          ),
        ),
      );

      expect(find.text('Kindergarten'), findsOneWidget);
      expect(find.text('Grade —'), findsOneWidget);
      expect(find.textContaining('Grade Grade'), findsNothing);
    });

    testWidgets('ClassCard renders long room text without RenderFlex overflow on narrow screens', (tester) async {
      const item = ClassModel(
        id: 4,
        name: 'Advanced Chemistry',
        grade: '12',
        room: 'Science Lab Building West Wing Suite 402B Room 10',
        teacher: ClassTeacherModel(
          id: 12,
          userId: 102,
          name: 'Dr. Christopher Alexander Montgomery Jr.',
          status: 'active',
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320, // narrow mobile viewport
              child: ClassCard(item: item),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Advanced Chemistry'), findsOneWidget);
      expect(find.text('Grade 12'), findsOneWidget);
    });
  });

  group('School Feature - Model Deserialization & Null Safety Tests', () {
    test('ClassModel parses verified API payload safely with null room and teacher', () {
      final json = {
        'id': 10,
        'name': 'Grade 1 Section A',
        'grade': '1',
        'room': null,
        'teacher_id': null,
        'teacher': null,
        'created_at': '2026-10-06T12:00:00Z',
        'updated_at': '2026-10-06T12:00:00Z',
      };

      final classModel = ClassModel.fromJson(json);

      expect(classModel.id, 10);
      expect(classModel.name, 'Grade 1 Section A');
      expect(classModel.grade, '1');
      expect(classModel.formattedGrade, 'Grade 1');
      expect(classModel.room, isNull);
      expect(classModel.teacherId, isNull);
      expect(classModel.teacher, isNull);
    });

    test('ClassModel correctly parses nested teacher and inactive status', () {
      final json = {
        'id': 12,
        'name': 'Grade 2 Section B',
        'grade': 'Grade 2',
        'room': 'Room 102',
        'teacher_id': 4,
        'teacher': {
          'id': 4,
          'user_id': 104,
          'name': 'John Doe',
          'status': 'inactive',
        },
      };

      final classModel = ClassModel.fromJson(json);

      expect(classModel.id, 12);
      expect(classModel.formattedGrade, 'Grade 2');
      expect(classModel.room, 'Room 102');
      expect(classModel.teacher, isNotNull);
      expect(classModel.teacher!.id, 4);
      expect(classModel.teacher!.userId, 104);
      expect(classModel.teacher!.name, 'John Doe');
      expect(classModel.teacher!.status, 'inactive');
      expect(classModel.teacher!.isInactive, isTrue);
    });

    test('SubjectModel parses verified API payload safely', () {
      final json = {
        'id': 5,
        'name': 'Mathematics',
        'description': 'Elementary Math Curriculum',
        'created_at': '2026-10-06T10:00:00Z',
        'updated_at': '2026-10-06T10:00:00Z',
      };

      final subject = SubjectModel.fromJson(json);

      expect(subject.id, 5);
      expect(subject.name, 'Mathematics');
      expect(subject.description, 'Elementary Math Curriculum');
    });
  });
}
