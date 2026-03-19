import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphic_card.dart';

class JobMatchScreen extends StatefulWidget {
  const JobMatchScreen({super.key});
  @override
  State<JobMatchScreen> createState() => _JobMatchScreenState();
}

class _JobMatchScreenState extends State<JobMatchScreen> with SingleTickerProviderStateMixin {
  final _jdController = TextEditingController();
  bool _analyzed = false;
  bool _loading = false;
  late AnimationController _animController;

  final _matchedSkills = ['Flutter', 'Dart', 'REST APIs', 'CI/CD', 'Agile', 'Git'];
  final _missingSkills = ['Kubernetes', 'GraphQL', 'AWS Lambda', 'Terraform'];

  void _analyze() async {
    if (_jdController.text.length < 50) return;
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _loading = false; _analyzed = true; });
    _animController.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _jdController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Match'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paste Job Description', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('We\'ll analyze how well your resume matches', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: _jdController,
              maxLines: 6,
              decoration: const InputDecoration(hintText: 'Paste the full job description here...'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _analyze,
                child: _loading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Analyze Match'),
              ),
            ),

            if (_analyzed) ...[
              const SizedBox(height: 32),
              FadeTransition(
                opacity: CurvedAnimation(parent: _animController, curve: Curves.easeOut),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match Score
                    Center(
                      child: GlassmorphicCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text('Match Score', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                            const SizedBox(height: 8),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(colors: [AppTheme.warning, AppTheme.success]).createShader(bounds),
                              child: const Text('73%', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                            const Text('Good match — a few gaps to close', style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Matched Skills
                    Text('Matched Skills', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _matchedSkills.map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
                            const SizedBox(width: 6),
                            Text(s, style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Missing Skills
                    Text('Missing Skills', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _missingSkills.map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cancel, color: AppTheme.error, size: 16),
                            const SizedBox(width: 6),
                            Text(s, style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Skill Gap Roadmap
                    Text('Skill Gap Roadmap', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ..._missingSkills.asMap().entries.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border, width: 0.5)),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Learn ${e.value}', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                                const Text('~2-4 weeks to add to resume', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
