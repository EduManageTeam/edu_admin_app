class ClassItem {
  final String name;
  final String room;
  final String teacher;
  final int students;
  final int capacity;

  const ClassItem({
    required this.name,
    required this.room,
    required this.teacher,
    required this.students,
    required this.capacity,
  });

  double get progress => students / capacity;
}
