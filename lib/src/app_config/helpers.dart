import 'package:client_data/client_data.dart';
import 'package:flutter/widgets.dart';
import 'package:platform/platform.dart' as platform;

Platform getCurrentPlatform([
  platform.Platform localPlatform = const platform.LocalPlatform(),
]) {
  if (localPlatform.isAndroid) {
    return Platform.android;
  }
  if (localPlatform.isIOS) {
    return Platform.iOS;
  }
  if (localPlatform.isMacOS) {
    return Platform.iOS;
  }
  throw UnsupportedError('unsupported platform exception');
}

String currentPlatformVersion() =>
    const platform.LocalPlatform().operatingSystemVersion;

String getLanguageCode(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

int getBuildNumber(String version) {
  final versionSegments = version.split('+');
  if (versionSegments.isEmpty) return 0;
  return int.tryParse(versionSegments.last) ?? 0;
}

String getBuildVersion(String version) {
  final versionSegments = version.split('+');
  if (versionSegments.isEmpty) return '1.0.0';
  return versionSegments.first;
}
