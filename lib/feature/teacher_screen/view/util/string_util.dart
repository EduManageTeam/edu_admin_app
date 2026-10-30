String getInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);

  final initials = parts.map((part) => part[0].toUpperCase()).join();

  return initials.isEmpty ? 'T' : initials;
}
