import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resumeai_mobile/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ResumeAIApp()));
    await tester.pumpAndSettle();
    expect(find.text('ResumeAI'), findsWidgets);
  });
}
