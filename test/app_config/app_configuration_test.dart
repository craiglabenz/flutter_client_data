import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart' as platform;

class MockPlatform extends Mock implements platform.Platform {}

platform.Platform iOSPlatform() {
  final platform = MockPlatform();
  when(() => platform.isAndroid).thenReturn(false);
  when(() => platform.isIOS).thenReturn(true);
  when(() => platform.isMacOS).thenReturn(false);
  return platform;
}

platform.Platform androidPlatform() {
  final platform = MockPlatform();
  when(() => platform.isAndroid).thenReturn(true);
  when(() => platform.isIOS).thenReturn(false);
  when(() => platform.isMacOS).thenReturn(false);
  return platform;
}

platform.Platform unknownPlatform() {
  final platform = MockPlatform();
  when(() => platform.isAndroid).thenReturn(false);
  when(() => platform.isIOS).thenReturn(false);
  when(() => platform.isMacOS).thenReturn(false);
  return platform;
}

void main() {
  group('currentPlatform', () {
    test('returns iOS when isIOS is true', () {
      expect(getCurrentPlatform(iOSPlatform()), Platform.iOS);
    });

    test('returns Android when isAndroid is true', () {
      expect(getCurrentPlatform(androidPlatform()), Platform.android);
    });

    test('throws unsupported when neither iOS or Android', () {
      expect(
        () => getCurrentPlatform(unknownPlatform()),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('platform is optional', () {
      expect(getCurrentPlatform(), isNotNull);
    });
  });

  group('buildNumber', () {
    test('is not null', () {
      expect(getBuildNumber('1'), isNotNull);
    });

    test('returns 0 when packageVersion is empty', () {
      expect(getBuildNumber(''), 0);
    });

    test('returns 0 when packageVersion is missing a build number', () {
      expect(getBuildNumber('1.0.0'), 0);
    });

    test('returns 0 when packageVersion has a malformed build number', () {
      expect(getBuildNumber('1.0.0+'), 0);
    });

    test('returns 42 when build number is 42', () {
      expect(getBuildNumber('1.0.0+42'), 42);
    });
  });
}
