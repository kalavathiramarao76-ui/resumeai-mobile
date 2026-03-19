import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class EditorScreen extends StatefulWidget {
  final String resumeId;
  const EditorScreen({super.key, required this.resumeId});
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _bullets = [
    _EditableBullet('Led development of mobile application serving 50K+ users', [
      'Spearheaded development of a flagship mobile application, driving adoption to 50K+ active users within 6 months',
      'Architected and shipped a cross-platform mobile app that scaled to 50K+ DAUs, reducing churn by 15%',
    ]),
    _EditableBullet('Managed team of 5 developers', [
      'Managed a cross-functional team of 5 engineers, delivering 12 features ahead of schedule across 3 sprints',
      'Led and mentored a team of 5 developers, improving sprint velocity by 30% through agile best practices',
    ]),
    _EditableBullet('Improved app performance', [
      'Optimized app performance by 40%, reducing load times from 3.2s to 1.8s through code splitting and lazy loading',
      'Drove 40% performance improvement by implementing caching strategies, reducing API calls by 60%',
    ]),
    _EditableBullet('Created REST APIs for backend services', [
      'Designed and implemented 15+ RESTful APIs handling 10K+ requests/minute with 99.9% uptime SLA',
      'Architected scalable REST API layer serving 10K+ RPM, with comprehensive test coverage and automated CI/CD',
    ]),
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Editor'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: () => HapticFeedback.mediumImpact(),
            child: const Text('Save', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.1), Colors.transparent]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.work_outline, color: AppTheme.primary, size: 20),
                SizedBox(width: 10),
                Text('Experience', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Senior Software Engineer', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
                SizedBox(height: 4),
                Text('Google • 2023 - Present', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bullet points
          ...List.generate(_bullets.length, (i) {
            final bullet = _bullets[i];
            final isExpanded = _expandedIndex == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isExpanded ? AppTheme.primary.withValues(alpha: 0.05) : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isExpanded ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border, width: isExpanded ? 1.5 : 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bullet text + tap target
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _expandedIndex = isExpanded ? null : i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6, height: 6,
                            decoration: const BoxDecoration(color: AppTheme.textSecondary, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(bullet.text, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, height: 1.5))),
                          const SizedBox(width: 8),
                          Icon(isExpanded ? Icons.close : Icons.auto_awesome, color: AppTheme.primary, size: 18),
                        ],
                      ),
                    ),
                  ),
                  // AI Suggestions
                  if (isExpanded) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(color: AppTheme.border, height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: AppTheme.secondary, size: 16),
                              SizedBox(width: 6),
                              Text('AI Suggestions', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(bullet.suggestions.length, (j) => Dismissible(
                            key: Key('${i}_$j'),
                            direction: DismissDirection.horizontal,
                            onDismissed: (dir) {
                              HapticFeedback.mediumImpact();
                              if (dir == DismissDirection.startToEnd) {
                                setState(() {
                                  _bullets[i] = _EditableBullet(bullet.suggestions[j], bullet.suggestions);
                                  _expandedIndex = null;
                                });
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                              child: const Row(children: [Icon(Icons.check, color: AppTheme.success), SizedBox(width: 8), Text('Accept', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w600))]),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: AppTheme.error.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Skip', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)), SizedBox(width: 8), Icon(Icons.close, color: AppTheme.error)]),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bullet.suggestions[j], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.4)),
                                  const SizedBox(height: 8),
                                  const Text('← Swipe right to accept | Swipe left to skip →', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EditableBullet {
  final String text;
  final List<String> suggestions;
  _EditableBullet(this.text, this.suggestions);
}
