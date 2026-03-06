import 'package:flutter_test/flutter_test.dart';
import 'package:netstats_pro/main.dart';

void main() {
  testWidgets('App starts', (tester) async {
    await tester.pumpWidget(const NetstatsProApp());
    expect(find.text('Netstats Pro'), findsWidgets);
  });
}
