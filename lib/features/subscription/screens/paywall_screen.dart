import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with SingleTickerProviderStateMixin {
  bool _isAnnual = true;
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1040), AppTheme.surface],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Crown icon
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.3), blurRadius: 20)],
                        ),
                        child: const Icon(Icons.workspace_premium, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      const Text('Unlock ResumeAI Pro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                      const SizedBox(height: 8),
                      const Text('Get unlimited access to all AI features', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                      const SizedBox(height: 32),

                      // Features
                      ...[
                        _Feature(Icons.all_inclusive, 'Unlimited resume scans'),
                        _Feature(Icons.auto_awesome, 'AI-powered bullet rewrites'),
                        _Feature(Icons.compare_arrows, 'Unlimited job matching'),
                        _Feature(Icons.auto_fix_high, 'One-tap optimization'),
                        _Feature(Icons.download, 'PDF export'),
                        _Feature(Icons.support_agent, 'Priority support'),
                      ].map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(f.icon, color: AppTheme.primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Text(f.label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 24),

                      // Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () { HapticFeedback.lightImpact(); setState(() => _isAnnual = false); },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !_isAnnual ? AppTheme.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text('Monthly', style: TextStyle(color: !_isAnnual ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                                      Text('\$9.99/mo', style: TextStyle(color: !_isAnnual ? Colors.white70 : AppTheme.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () { HapticFeedback.lightImpact(); setState(() => _isAnnual = true); },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _isAnnual ? AppTheme.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Annual', style: TextStyle(color: _isAnnual ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: AppTheme.success, borderRadius: BorderRadius.circular(4)),
                                            child: const Text('SAVE 50%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                      Text('\$4.99/mo', style: TextStyle(color: _isAnnual ? Colors.white70 : AppTheme.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // CTA
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: AnimatedBuilder(
                          animation: _shineController,
                          builder: (context, child) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: const [AppTheme.primary, AppTheme.secondary, AppTheme.primary],
                                stops: [0, _shineController.value, 1],
                              ),
                            ),
                            child: child,
                          ),
                          child: ElevatedButton(
                            onPressed: () { HapticFeedback.heavyImpact(); },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                            child: const Text('Start 3-Day Free Trial', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Restore Purchases', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Cancel anytime. No commitment.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String label;
  _Feature(this.icon, this.label);
}
