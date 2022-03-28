import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../shared/constants.dart';

// NOTE update value of "app_version_adminapp" in Firebase Remote Config when new release
const String _remoteAppVersion = Constants.rcAppVersionRef;

// NOTE update value of _currentAppVersion for every release so
// it is the same as Firebase Remote Config
const String _currentAppVersion = Constants.rcCurrentAppVersionRef;

class RemoteConfigService {
  final defaults = <String, dynamic>{
    _remoteAppVersion: "Error - no information",
  };

  final FirebaseRemoteConfig _remoteConfig;

  static final RemoteConfigService _instance = RemoteConfigService(
    remoteConfig: FirebaseRemoteConfig.instance,
  );

  static RemoteConfigService get instance => _instance;

  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  String get getRemoteAppVersionValue =>
      _remoteConfig.getString(_remoteAppVersion);
  String get getCurrentAppVersionValue => _currentAppVersion;

  bool get needUpdate =>
      _remoteConfig.getString(_remoteAppVersion) != _currentAppVersion;

  Future initialise() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log(e.toString());
      // Unable to fetch remote config. Cached or default values will be used
    }
  }
}
