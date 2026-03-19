import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/score_ring.dart';
import '../../../core/widgets/glassmorphic_card.dart';

class AnalysisScreen extends StatefulWidget {
  final String resumeId;
  const AnalysisScreen({super.key, required this.resumeId});
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;

  final _sections = [
    _ScoreSection('Formatting', 85, AppTheme.success, Icons.format_align_left),
    _ScoreSection('Content Quality', 68, AppTheme.warning, Icons.article),
    _ScoreSection('Keywords', 55, AppTheme.error, Icons.key),
    _ScoreSection('Impact Words', 72, AppTheme.accent, Icons.bolt),
    _ScoreSection('Brevity', 80, AppTheme.success, Icons.short_text),
  ];

  final _suggestions = [
    'Add 3-5 more industry-specific keywords to your skills section',
    'Quantify achievements in your experience section (use numbers, %, \$)',
    'Replace "responsible for" with action verbs like "led", "drove", "built"',
    'Add a professional summary at the top (2-3 sentences)',
    'Remove outdated skills and technologies',
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton.icon(
            onPressed: () => HapticFeedback.mediumImpact(),
            icon: const Icon(Icons.auto_fix_high, color: AppTheme.success, size: 18),
            label: const Text('Fix All', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Score
            Center(
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const ScoreRing(score: 72, size: 180, strokeWidth: 14),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Needs Improvement', style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Section Scores
            Text('Section Scores', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(_sections.length, (i) {
              final s = _sections[i];
              return AnimatedBuilder(
                animation: _staggerController,
                builder: (context, child) {
                  final delay = i * 0.15;
                  final progress = ((_staggerController.value - delay) / (1 - delay)).clamp(0.0, 1.0);
                  return Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - progress)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(s.icon, color: s.color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.label, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: s.score / 100,
                                backgroundColor: AppTheme.border,
                                color: s.color,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text('${s.score}', style: TextStyle(color: s.color, fontWeight: FontWeight.w700, fontSize: 18)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            Text('AI Suggestions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(_suggestions.length, (i) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Text('${i + 1}', style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_suggestions[i], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.4))),
                ],
              ),
            )),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => HapticFeedback.heavyImpact(),
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('One-Tap Optimize'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ScoreSection {
  final String label;
  final int score;
  final Color color;
  final IconData icon;
  _ScoreSection(this.label, this.score, this.color, this.icon);
}
