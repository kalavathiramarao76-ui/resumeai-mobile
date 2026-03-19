import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphic_card.dart';
import '../../../core/widgets/score_ring.dart';
import '../../../providers/app_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    ref.read(resumeListProvider.notifier).loadResumes();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final resumes = ref.watch(resumeListProvider);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hey, ${user?.name ?? 'there'} 👋', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 4),
                          Text('Your career copilot is ready', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/career-feed'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: const Icon(Icons.tips_and_updates_outlined, color: AppTheme.accent, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Score Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GlassmorphicCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const ScoreRing(score: 72),
                        const SizedBox(height: 20),
                        const Text('Your resume needs improvements', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () { HapticFeedback.mediumImpact(); },
                            icon: const Icon(Icons.auto_fix_high, size: 20),
                            label: const Text('Fix My Resume'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.success,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _ActionCard(icon: Icons.upload_file_rounded, label: 'Upload\nResume', color: AppTheme.primary, onTap: () { HapticFeedback.lightImpact(); }),
                          const SizedBox(width: 12),
                          _ActionCard(icon: Icons.compare_arrows_rounded, label: 'Job\nMatch', color: AppTheme.accent, onTap: () { HapticFeedback.lightImpact(); context.push('/job-match'); }),
                          const SizedBox(width: 12),
                          _ActionCard(icon: Icons.stars_rounded, label: 'Go\nPro', color: AppTheme.secondary, onTap: () { HapticFeedback.lightImpact(); context.push('/paywall'); }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Insights
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Insights', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      _InsightCard(icon: Icons.warning_amber_rounded, title: 'Weak Action Verbs', subtitle: '5 bullet points need stronger verbs', color: AppTheme.warning),
                      const SizedBox(height: 12),
                      _InsightCard(icon: Icons.trending_up, title: 'Add Metrics', subtitle: '3 bullets lack quantifiable results', color: AppTheme.accent),
                      const SizedBox(height: 12),
                      _InsightCard(icon: Icons.check_circle_outline, title: 'Good Formatting', subtitle: 'ATS-friendly structure detected', color: AppTheme.success),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      // Bottom Nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border.withValues(alpha: 0.5))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Home', active: true, onTap: () {}),
                _NavItem(icon: Icons.description_rounded, label: 'Resumes', onTap: () {}),
                _NavItem(icon: Icons.edit_rounded, label: 'Editor', onTap: () => context.push('/editor/1')),
                _NavItem(icon: Icons.person_rounded, label: 'Profile', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _InsightCard({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? AppTheme.primary : AppTheme.textSecondary, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: active ? AppTheme.primary : AppTheme.textSecondary, fontSize: 11, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}
