import 'package:app_settings/app_settings.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/screens/failed/failed_permission.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPermission {
  BuildContext context;

  AppPermission(this.context);

  void displayDialogPermission() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text(Local.permissionTitle),
              content: const Text(Local.permissionUsage),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text(Local.denie),
                    onPressed: () => _refuseToChangeSettings()),
                CupertinoDialogAction(
                  child: const Text(Local.settings),
                  onPressed: () => _acceptToChangeSettings(),
                ),
              ],
            ));
  }

  void _refuseToChangeSettings() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const FailedPermission()));
  }

  void _acceptToChangeSettings() async {
    AppSettings.openAppSettings();
    Navigator.of(context, rootNavigator: true).pop("Settings");
  }
}
