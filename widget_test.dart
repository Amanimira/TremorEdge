// هذا اختبار واجهات أساسي لتطبيق Tremor Guard.
//
// WidgetTester يسمح لك تتفاعل مع الواجهة (ضغط، سحب، إيجاد Widgets، إلخ).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremor_ring_app/main.dart';

void main() {
  testWidgets('Tremor Guard app smoke test', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل أول فريم
    await tester.pumpWidget(const MyApp());

    // انتظار انتهاء أي animations أو شاشات تحميل
    await tester.pumpAndSettle();

    // التحقق أن التطبيق يعمل وأن العنوان موجود
    expect(find.text('Tremor Guard'), findsWidgets);

    // عدّل النصوص هنا لتطابق ما هو موجود فعليًا في شاشة الهوم عندك
    expect(find.text('Home'), findsWidgets);
  });

  testWidgets('Navigation bar test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // لو عندك BottomNavigationBar بهذه العناوين، الاختبار يمر
    // لو تختلف، غيّر النصوص لتطابق الموجود في HomeScreen
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Analytics'), findsWidgets);
    expect(find.text('Meds'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('SOS button exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // التحقق أن زر SOS (غالبًا FloatingActionButton) موجود
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
