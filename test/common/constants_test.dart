import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/constants.dart';

void main() {
  group('Constants', () {
    group('URLs', () {
      test('baseImageUrl should have correct value', () {
        expect(baseImageUrl, 'https://image.tmdb.org/t/p/w500');
      });
    });

    group('Colors', () {
      test('kRichBlack should be correct color', () {
        expect(kRichBlack, const Color(0xFF000814));
      });

      test('kOxfordBlue should be correct color', () {
        expect(kOxfordBlue, const Color(0xFF001D3D));
      });

      test('kPrussianBlue should be correct color', () {
        expect(kPrussianBlue, const Color(0xFF003566));
      });

      test('kMikadoYellow should be correct color', () {
        expect(kMikadoYellow, const Color(0xFFffc300));
      });

      test('kDavysGrey should be correct color', () {
        expect(kDavysGrey, const Color(0xFF4B5358));
      });

      test('kGrey should be correct color', () {
        expect(kGrey, const Color(0xFF303030));
      });
    });

    group('ColorScheme', () {
      test('kColorScheme should have correct primary color', () {
        expect(kColorScheme.primary, kMikadoYellow);
      });

      test('kColorScheme should have correct secondary color', () {
        expect(kColorScheme.secondary, kPrussianBlue);
      });

      test('kColorScheme should have correct surface color', () {
        expect(kColorScheme.surface, kRichBlack);
      });

      test('kColorScheme should have correct brightness', () {
        expect(kColorScheme.brightness, Brightness.dark);
      });

      test('kColorScheme should have correct onPrimary color', () {
        expect(kColorScheme.onPrimary, kRichBlack);
      });

      test('kColorScheme should have correct onSecondary color', () {
        expect(kColorScheme.onSecondary, Colors.white);
      });

      test('kColorScheme should have correct onSurface color', () {
        expect(kColorScheme.onSurface, Colors.white);
      });

      test('kColorScheme should have correct onError color', () {
        expect(kColorScheme.onError, Colors.white);
      });

      test('kColorScheme should have error color as red', () {
        expect(kColorScheme.error, Colors.red);
      });
    });
  });

  group('Constants Widget Tests', () {
    testWidgets('kTextTheme should be used in theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: kTextTheme,
            colorScheme: kColorScheme,
            drawerTheme: kDrawerTheme,
          ),
          home: Scaffold(
            body: Center(child: Text('Test', style: kHeading5)),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('kSubtitle and kBodyText should be accessible', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Subtitle', style: kSubtitle),
                Text('Body', style: kBodyText),
                Text('Heading5', style: kHeading5),
                Text('Heading6', style: kHeading6),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Heading5'), findsOneWidget);
      expect(find.text('Heading6'), findsOneWidget);
    });

    testWidgets('kDrawerTheme should be used in theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            drawerTheme: kDrawerTheme,
            colorScheme: kColorScheme,
          ),
          home: const Scaffold(body: Center(child: Text('Theme Test'))),
        ),
      );

      expect(find.text('Theme Test'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
