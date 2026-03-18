import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quran_app/main.dart';

void main() {
  testWidgets('QuranApp renders bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: QuranApp()));
    await tester.pumpAndSettle();

    expect(find.text('Уроки'), findsWidgets);
    expect(find.text('Прогресс'), findsOneWidget);
    expect(find.text('Повторения'), findsOneWidget);
  });
}
