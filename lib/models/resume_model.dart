class ResumeModel {
  final String id;
  final String name;
  final String? fileUrl;
  final ResumeScore? score;
  final List<ResumeSection> sections;
  final DateTime createdAt;
  final DateTime updatedAt;

  ResumeModel({
    required this.id,
    required this.name,
    this.fileUrl,
    this.score,
    this.sections = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
    id: json['id'].toString(),
    name: json['name'] ?? 'Untitled Resume',
    fileUrl: json['file_url'],
    score: json['score'] != null ? ResumeScore.fromJson(json['score']) : null,
    sections: (json['sections'] as List? ?? []).map((s) => ResumeSection.fromJson(s)).toList(),
    createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
  );
}

class ResumeScore {
  final int overall;
  final int formatting;
  final int content;
  final int keywords;
  final int impact;
  final int brevity;
  final List<String> suggestions;

  ResumeScore({
    required this.overall,
    required this.formatting,
    required this.content,
    required this.keywords,
    required this.impact,
    required this.brevity,
    this.suggestions = const [],
  });

  factory ResumeScore.fromJson(Map<String, dynamic> json) => ResumeScore(
    overall: json['overall'] ?? 0,
    formatting: json['formatting'] ?? 0,
    content: json['content'] ?? 0,
    keywords: json['keywords'] ?? 0,
    impact: json['impact'] ?? 0,
    brevity: json['brevity'] ?? 0,
    suggestions: List<String>.from(json['suggestions'] ?? []),
  );
}

class ResumeSection {
  final String id;
  final String type;
  final String title;
  final List<BulletPoint> bullets;

  ResumeSection({required this.id, required this.type, required this.title, this.bullets = const []});

  factory ResumeSection.fromJson(Map<String, dynamic> json) => ResumeSection(
    id: json['id'].toString(),
    type: json['type'] ?? '',
    title: json['title'] ?? '',
    bullets: (json['bullets'] as List? ?? []).map((b) => BulletPoint.fromJson(b)).toList(),
  );
}

class BulletPoint {
  final String id;
  final String text;
  final int? impactScore;
  final List<String> aiSuggestions;

  BulletPoint({required this.id, required this.text, this.impactScore, this.aiSuggestions = const []});

  factory BulletPoint.fromJson(Map<String, dynamic> json) => BulletPoint(
    id: json['id'].toString(),
    text: json['text'] ?? '',
    impactScore: json['impact_score'],
    aiSuggestions: List<String>.from(json['ai_suggestions'] ?? []),
  );
}
