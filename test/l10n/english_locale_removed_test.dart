import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

void main() {
  group('English locale removal', () {
    final projectRoot = Directory.current.path;

    test('app_en.arb should not exist', () {
      final file = File('$projectRoot/lib/l10n/app_en.arb');
      expect(file.existsSync(), isFalse);
    });

    test('app_localizations_en.dart should not exist', () {
      final file = File('$projectRoot/lib/l10n/app_localizations_en.dart');
      expect(file.existsSync(), isFalse);
    });

    test('supportedLocales should only contain Spanish', () {
      expect(
        AppLocalizations.supportedLocales,
        equals(const <Locale>[Locale('es')]),
      );
    });

    test('delegate should only support Spanish', () {
      expect(AppLocalizations.delegate.isSupported(const Locale('es')), isTrue);
      expect(AppLocalizations.delegate.isSupported(const Locale('en')), isFalse);
    });

    test('lookupAppLocalizations should throw for unsupported English locale', () {
      expect(
        () => lookupAppLocalizations(const Locale('en')),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
