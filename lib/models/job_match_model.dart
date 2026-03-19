class JobMatchModel {
  final int matchPercentage;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> suggestions;
  final Map<String, int> sectionScores;

  JobMatchModel({
    required this.matchPercentage,
    required this.matchedSkills,
    required this.missingSkills,
    required this.suggestions,
    required this.sectionScores,
  });

  factory JobMatchModel.fromJson(Map<String, dynamic> json) => JobMatchModel(
    matchPercentage: json['match_percentage'] ?? 0,
    matchedSkills: List<String>.from(json['matched_skills'] ?? []),
    missingSkills: List<String>.from(json['missing_skills'] ?? []),
    suggestions: List<String>.from(json['suggestions'] ?? []),
    sectionScores: Map<String, int>.from(json['section_scores'] ?? {}),
  );
}
