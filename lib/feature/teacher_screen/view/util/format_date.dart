// Format joined date
String formatDate(DateTime? date) {
  if (date == null) return 'Not available';

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final local = date.toLocal();

  return '${local.day} ${months[local.month - 1]} ${local.year}';
}
