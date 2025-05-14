class DashboardStats {
  final int totalStudents;
  final int totalProperties;
  final int totalOwners;
  final double monthlyRent;

  DashboardStats({
    this.totalStudents = 0,
    this.totalProperties = 0,
    this.totalOwners = 0,
    this.monthlyRent = 0.0,
  });

  // Create from API response
  factory DashboardStats.fromMap(Map<String, dynamic> map) {
    return DashboardStats(
      totalStudents: map['totalStudents'] ?? 0,
      totalProperties: map['totalProperties'] ?? 0,
      totalOwners: map['totalOwners'] ?? 0,
      monthlyRent: (map['monthlyRent'] ?? 0).toDouble(),
    );
  }

  // Create an empty stats object
  factory DashboardStats.empty() {
    return DashboardStats();
  }

  // Clone this object with some updated values
  DashboardStats copyWith({
    int? totalStudents,
    int? totalProperties,
    int? totalOwners,
    double? monthlyRent,
  }) {
    return DashboardStats(
      totalStudents: totalStudents ?? this.totalStudents,
      totalProperties: totalProperties ?? this.totalProperties,
      totalOwners: totalOwners ?? this.totalOwners,
      monthlyRent: monthlyRent ?? this.monthlyRent,
    );
  }
}