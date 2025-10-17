import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ianctchinese/main.dart';

void main() {
  testWidgets('App launches test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
