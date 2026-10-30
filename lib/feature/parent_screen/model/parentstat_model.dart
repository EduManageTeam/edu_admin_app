class ParentStats {
  final int total;
  final int linked;
  final int unlinked;

  const ParentStats({
    required this.total,
    required this.linked,
    required this.unlinked,
  });

  factory ParentStats.fromJson(Map<String, dynamic> json) {
    return ParentStats(
      total: int.tryParse('${json['total']}') ?? 0,
      linked: int.tryParse('${json['linked']}') ?? 0,
      unlinked: int.tryParse('${json['unlinked']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'linked': linked, 'unlinked': unlinked};
  }
}
