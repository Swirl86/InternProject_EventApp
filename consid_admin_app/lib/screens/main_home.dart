import 'dart:developer';

import 'package:admin_app/screens/eventdata_edit.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:admin_app/screens/list_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';
import '../theme/custom_colors.dart';
import 'manual_handler.dart';
import 'print_achievements.dart';
import 'scanning.dart';
import 'superadmin/create_handler.dart';
import 'superadmin/list_achivements_all.dart';
import 'superadmin/list_invites.dart';

// Globals
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {
  // References
  final AuthService _authService = AuthService();
  final User? user = _firebaseAuth.currentUser;

  final RemoteConfigService _remoteConfigService = RemoteConfigService.instance;
  bool _gotUpdate = false;

  void _setUpdateState() {
    setState(() {
      _gotUpdate = _remoteConfigService.needUpdate;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _setUpdateState();
      if (_gotUpdate) {
        Future.delayed(Duration.zero, () => _showUpdateAlertDialog());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Scrollbar(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 1,
            ),
            child: IntrinsicHeight(
                child: Column(children: <Widget>[
              SizedBox(height: _screenSize.height * 0.075),
              (user?.email == Constants.superAdmin)
                  ? defaultTextTitle(
                      _screenSize,
                      LocalVar.superadmin.toUpperCase(),
                      _screenSize.width * 0.11)
                  : defaultTextTitle(
                      _screenSize,
                      LocalVar.eventAdmin.toUpperCase(),
                      _screenSize.width * 0.11),
              SizedBox(height: _screenSize.height * 0.01),
              defaultDivider(),
              SizedBox(height: _screenSize.height * 0.01),
              defaultTextButton(context, LocalVar.scan.toUpperCase(), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Scanning()));
              }),
              defaultTextButton(context, LocalVar.manually.toUpperCase(), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManualHandler()));
              }),
              Visibility(
                visible: user?.email == Constants.superAdmin,
                child: defaultTextButton(context, LocalVar.create.toUpperCase(),
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateHandler()));
                }),
              ),
              SizedBox(height: _screenSize.height * 0.01),
              defaultTextButtonWithIcon(
                context,
                Icons.playlist_add_check,
                LocalVar.listParticipants.toUpperCase(),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListHandler()));
                },
                _screenSize.width * 0.11,
                _screenSize.width * 0.05,
              ),
              defaultTextButtonWithIcon(
                context,
                Icons.print,
                LocalVar.print.toUpperCase(),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrintAchieve()));
                },
                _screenSize.width * 0.09,
                _screenSize.width * 0.05,
              ),
              Visibility(
                  visible: user?.email == Constants.superAdmin,
                  child: Column(children: [
                    defaultTextButtonWithIcon(
                        context,
                        Icons.format_list_numbered_outlined,
                        LocalVar.listUnusedInvites.toUpperCase(), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListInvites()));
                    }, _screenSize.width * 0.085),
                    defaultTextButtonWithIcon(context, Icons.done_all_sharp,
                        LocalVar.listAchievements.toUpperCase(), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ListAchievementsAll()));
                    }, _screenSize.width * 0.085),
                    defaultTextButtonWithIcon(
                        context, Icons.edit, LocalVar.editEvent.toUpperCase(),
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventDataEdit()));
                    }, _screenSize.width * 0.085),
                  ])),
              bottomPart(_screenSize),
            ])),
          ),
        )));
  }

  bottomPart(dynamic _screenSize) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton.icon(
              icon: Icon(Icons.logout_rounded,
                  color: Theme.of(context).primaryColor,
                  size: _screenSize.width * 0.11),
              label: Text(
                LocalVar.logOut.toUpperCase(),
                style: CustomTextStyle.defaultStyle.copyWith(
                    fontSize: _screenSize.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                await _authService.signOut(context);
              }),
          bottomLogo(_screenSize) // Company logo
        ],
      ),
    );
  }

  _showUpdateAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColors.tabUnchosenBg,
            title: gotUpdateAlertTitle(context),
            content: gotUpdateAlertContent(
                context,
                _remoteConfigService.getCurrentAppVersionValue,
                _remoteConfigService.getRemoteAppVersionValue),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    setState(() {
                      _gotUpdate = false;
                    });
                  },
                  child: gotUpdateAlertBtn()),
            ],
          );
        });
  }
}
