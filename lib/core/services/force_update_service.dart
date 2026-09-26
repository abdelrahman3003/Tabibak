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
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults(const {
        'tabibak_clinic_ios_minimum_build': '0',
        'tabibak_clinic_android_minimum_build': '0',
        'tabibak_clinic_android_store_url': '',
        'tabibak_clinic_ios_store_url': '',
      });

      await _remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();

      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final minimumBuild = defaultTargetPlatform == TargetPlatform.iOS
          ? _remoteConfig.getInt('tabibak_clinic_ios_minimum_build')
          : _remoteConfig.getInt('tabibak_clinic_android_minimum_build');

      return currentBuild < minimumBuild;
    } catch (error, stackTrace) {
      debugPrint(
        'Could not check required app update: $error\n$stackTrace',
      );

      return false;
    }
  }

  static String get storeUrl {
    final key = defaultTargetPlatform == TargetPlatform.iOS
        ? 'tabibak_clinic_ios_store_url'
        : 'tabibak_clinic_android_store_url';

    return _remoteConfig.getString(key).trim();
  }
}
