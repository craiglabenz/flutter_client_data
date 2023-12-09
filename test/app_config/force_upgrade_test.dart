import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForceUpgrade', () {
    test('supports value equality', () {
      expect(
        const ForceUpgrade(isUpgradeRequired: false),
        const ForceUpgrade(isUpgradeRequired: false),
      );
      expect(
        const ForceUpgrade(isUpgradeRequired: true),
        isNot(const ForceUpgrade(isUpgradeRequired: false)),
      );
    });

    group('ForceUpgradeX', () {
      test('is correct for Platform.android', () {
        expect(Platform.android.isAndroid, isTrue);
        expect(Platform.android.isIos, isFalse);
      });

      test('is correct for Platform.iOS', () {
        expect(Platform.iOS.isAndroid, isFalse);
        expect(Platform.iOS.isIos, isTrue);
      });
    });
  });
}
