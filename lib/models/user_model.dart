class UserModel {
  final String id;
  final String email;
  final String name;
  final String plan;
  final int scansUsed;
  final int scansLimit;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.plan,
    required this.scansUsed,
    required this.scansLimit,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    plan: json['plan'] ?? 'free',
    scansUsed: json['scans_used'] ?? 0,
    scansLimit: json['scans_limit'] ?? 3,
    createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
  );

  bool get isPro => plan == 'pro';
  bool get canScan => isPro || scansUsed < scansLimit;
}
