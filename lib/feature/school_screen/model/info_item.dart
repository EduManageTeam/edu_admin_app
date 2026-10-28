
class InfoItem {
  final String title;
  final String subtitle;

  const InfoItem({required this.title, required this.subtitle});

  String get letter => title[0].toUpperCase();
}
