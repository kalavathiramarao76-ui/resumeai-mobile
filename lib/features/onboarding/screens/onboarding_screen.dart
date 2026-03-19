import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.auto_awesome_rounded,
      title: 'AI-Powered\nResume Analysis',
      subtitle: 'Get instant ATS scores and actionable improvements powered by advanced AI.',
      gradient: [AppTheme.primary, AppTheme.secondary],
    ),
    _OnboardingPage(
      icon: Icons.edit_note_rounded,
      title: 'Smart Resume\nEditor',
      subtitle: 'Tap any bullet point for AI-powered rewrites. Swipe to accept the best suggestion.',
      gradient: [AppTheme.secondary, AppTheme.accent],
    ),
    _OnboardingPage(
      icon: Icons.rocket_launch_rounded,
      title: 'Land Your\nDream Job',
      subtitle: 'Match resumes to job descriptions, optimize with one tap, and track your progress.',
      gradient: [AppTheme.accent, AppTheme.success],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) {
              final p = _pages[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.surface, AppTheme.surface.withValues(alpha: 0.95)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: p.gradient),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(p.icon, size: 56, color: Colors.white),
                        ),
                        const SizedBox(height: 48),
                        Text(p.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 16),
                        Text(p.subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5)),
                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Dots + Button
          Positioned(
            bottom: 60,
            left: 32,
            right: 32,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i ? AppTheme.primary : AppTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (_page < 2) {
                        _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      } else {
                        context.go('/auth');
                      }
                    },
                    child: Text(_page < 2 ? 'Next' : 'Get Started'),
                  ),
                ),
                if (_page < 2) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/auth'),
                    child: const Text('Skip', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  _OnboardingPage({required this.icon, required this.title, required this.subtitle, required this.gradient});
}
