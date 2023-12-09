import 'package:client_data/client_data.dart';

/// Indicator for the nature of the runtime - for real, for development, or
/// tests.
enum Environment {
  /// Indicates the app is in the hands of real end users.
  prod,

  /// Indicates the app is in the hands of beta testers.
  qa,

  /// Indicates the app is being actively being developed.
  dev,

  /// Indicates we are running in a `flutter test` simulation.
  test
}

/// Container for all the answers to that famous question from Lost:
/// "Where are we?"
class AppDetails {
  /// Const constructor.
  const AppDetails({
    required this.apiBaseUrl,
    required this.appVersion,
    required this.environment,
    required this.buildNumber,
    required this.os,
    required this.osVersion,
  }) : assert(buildNumber > 0, 'buildNumber must be a positive integer');

  factory AppDetails.live({
    required String apiBaseUrl,
    required Environment env,
    required String version,
  }) =>
      AppDetails(
        apiBaseUrl: apiBaseUrl,
        appVersion: getBuildVersion(version),
        buildNumber: getBuildNumber(version),
        environment: env,
        os: getCurrentPlatform(),
        osVersion: currentPlatformVersion(),
      );

  factory AppDetails.fake() => const AppDetails(
        apiBaseUrl: 'https://fake.com',
        appVersion: 'fake',
        environment: Environment.test,
        buildNumber: 1,
        os: Platform.iOS,
        osVersion: '1',
      );

  /// Scheme, host, and TLD of the main Django REST API
  final String apiBaseUrl;

  /// App version string pulled from pubspec.yaml
  final String appVersion;

  /// Dev/Prod/etc
  final Environment environment;

  /// App build number pulled from pubspec.yaml.
  final int buildNumber;

  /// Runtime OS
  final Platform os;

  /// Version of the OS.
  final String osVersion;
}
