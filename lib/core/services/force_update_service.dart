import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateService {
  ForceUpdateService._();

  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<bool> isUpdateRequired() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults({
        'tabibak_ios_minimum_build': '0',
        'tabibak_android_minimum_build': '0',
        'tabibak_ios_store_url': '',
        'tabibak_android_store_url': '',
        'minimum_supported_version': '',
        'android_store_url': '',
        'ios_store_url': '',
      });

      try {
        await _remoteConfig.fetchAndActivate();
      } catch (error) {
        debugPrint(
          'Remote Config fetch failed; using cached values: $error',
        );
      }

      final packageInfo = await PackageInfo.fromPlatform();

      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final platformSuffix =
          defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

      final minimumBuild = _remoteConfig.getInt(
        'tabibak_${platformSuffix}_minimum_build',
      );

      if (minimumBuild > 0) {
        return currentBuild < minimumBuild;
      }

      final minimumVersion =
          _remoteConfig.getString('minimum_supported_version').trim();

      if (minimumVersion.isEmpty) {
        return false;
      }

      return _compareVersions(
            packageInfo.version,
            minimumVersion,
          ) <
          0;
    } catch (error, stackTrace) {
      debugPrint(
        'Could not check required app update: $error\n$stackTrace',
      );

      return false;
    }
  }

  static String get storeUrl {
    final platformSuffix =
        defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

    final platformKey = 'tabibak_${platformSuffix}_store_url';

    final legacyKey = defaultTargetPlatform == TargetPlatform.iOS
        ? 'ios_store_url'
        : 'android_store_url';

    final platformUrl = _remoteConfig.getString(platformKey).trim();

    if (platformUrl.isNotEmpty) {
      return platformUrl;
    }

    return _remoteConfig.getString(legacyKey).trim();
  }

  static int _compareVersions(
    String current,
    String minimum,
  ) {
    final currentParts = _parseVersion(current);
    final minimumParts = _parseVersion(minimum);

    if (currentParts == null || minimumParts == null) {
      return 0;
    }

    final length = currentParts.length > minimumParts.length
        ? currentParts.length
        : minimumParts.length;

    for (var index = 0; index < length; index++) {
      final currentPart = index < currentParts.length ? currentParts[index] : 0;

      final minimumPart = index < minimumParts.length ? minimumParts[index] : 0;

      if (currentPart != minimumPart) {
        return currentPart.compareTo(minimumPart);
      }
    }

    return 0;
  }

  static List<int>? _parseVersion(String version) {
    final parts = version.split('+').first.split('.');
    final numbers = <int>[];

    for (final part in parts) {
      final number = int.tryParse(part);

      if (number == null) {
        return null;
      }

      numbers.add(number);
    }

    return numbers;
  }
}
