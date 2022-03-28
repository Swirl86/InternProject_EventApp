import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/event.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/main_screen.dart';
import 'package:consid_event_app/screens/not_checked_in/rsvp_code.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/services/remote_config_service.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeSplashScreen extends StatefulWidget {
  final Event? event;
  const WelcomeSplashScreen({Key? key, this.event}) : super(key: key);

  @override
  _WelcomeSplashScreenState createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen> {
  final RemoteConfigService _remoteConfigService = RemoteConfigService.instance;
  FireDatabase db = FireDatabase();
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
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          _checkCurrentState();
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              showInformationDialog(context);
            },
            child: infoIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: InkWell(
        onTap: () {
          _checkCurrentState();
        },
        child: Container(
          margin: Constants.sideMargins,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              sizedBoxSpacing(_currentHeight),
              Center(
                child: Text(
                  Local.welcomeSplashTitle,
                  style: CustomTextStyle.titleText
                      .copyWith(fontSize: _currentWidth * 0.15),
                  textAlign: TextAlign.center,
                ),
              ),
              bottomLogo(),
              sizedBoxSpacing(_currentHeight, 0.05),
            ],
          ),
        ),
      ),
    );
  }

  void _checkCurrentState() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(Constants.keySharPref)) {
      bool existInCurrentEvent = await db.checkCurrentGuestCode(
          context, prefs.getString(Constants.keySharPref));
      if (existInCurrentEvent) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const RsvpCode()));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const RsvpCode()));
    }
  }

  _showUpdateAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColors.unChosenBg,
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
                    if (!_gotUpdate) {
                      Future.delayed(const Duration(seconds: 3), () {
                        _checkCurrentState();
                      });
                    }
                  },
                  child: gotUpdateAlertBtn()),
              /* TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                    } else if (Platform.isIOS) {}
                  },
                  child: const Text("Update now"))*/
            ],
          );
        });
  }
}
