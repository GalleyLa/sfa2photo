class ReportEntity {
  final String id;
  final String name;
  final String phone;

  ReportEntity({required this.id, required this.name, required this.phone});

  ReportEntity copyWith({String? id, String? name, String? phone}) {
    return ReportEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}
