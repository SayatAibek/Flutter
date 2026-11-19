import 'package:flutter_test/flutter_test.dart';
import 'package:reading_club/main.dart';

void main() {
  testWidgets('Reading Club shows the seeded books', (tester) async {
    await tester.pumpWidget(const ReadingClubApp());
    await tester.pumpAndSettle();

    expect(find.text('Books'), findsWidgets);
    expect(find.text('The Alchemist'), findsOneWidget);
  });
}
