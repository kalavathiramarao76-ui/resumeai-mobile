import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CareerFeedScreen extends StatelessWidget {
  const CareerFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      _Tip('Trending Skill Alert', 'AI/ML skills are in 78% of senior roles this month. Consider adding relevant projects.', Icons.trending_up, AppTheme.accent),
      _Tip('Resume Tip', 'Resumes with quantified achievements get 40% more callbacks. Add metrics to at least 3 bullets.', Icons.tips_and_updates, AppTheme.warning),
      _Tip('Industry Insight', 'Remote-first companies grew 23% in Q1 2026. Highlight remote collaboration skills.', Icons.insights, AppTheme.secondary),
      _Tip('Weekly Challenge', 'Rewrite your summary section this week. Strong summaries increase ATS scores by 15%.', Icons.emoji_events, AppTheme.success),
      _Tip('Skill Suggestion', 'Based on your resume, learning Kubernetes could open 200+ more job matches.', Icons.school, AppTheme.primary),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Feed'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final tip = tips[i];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tip.color.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: tip.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(tip.icon, color: tip.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(tip.title, style: TextStyle(color: tip.color, fontWeight: FontWeight.w700, fontSize: 16))),
                    const Text('Today', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 14),
                Text(tip.desc, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, height: 1.5)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Tip {
  final String title, desc;
  final IconData icon;
  final Color color;
  _Tip(this.title, this.desc, this.icon, this.color);
}
