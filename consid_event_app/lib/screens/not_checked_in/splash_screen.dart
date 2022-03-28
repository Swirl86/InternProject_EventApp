import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/event.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/not_checked_in/count_down.dart';
import 'package:consid_event_app/screens/not_checked_in/rsvp_code.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/services/remote_config_service.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'its_time_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RemoteConfigService _remoteConfigService = RemoteConfigService.instance;
  FireDatabase db = FireDatabase();
  bool _eventNotEnded = false;
  bool _eventStarted = false;
  bool _gotUpdate = false;

  void _setStates() {
    setState(() {
      _gotUpdate = _remoteConfigService.needUpdate;
      _eventNotEnded = Event.instance?.endDate == null
          ? false
          : getTimeDifference(Event.instance?.endDate.seconds.toString()) >= 0;
      _eventStarted = Event.instance?.startDate == null
          ? false
          : getTimeDifference(Event.instance?.startDate.seconds.toString()) <=
              0;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _setStates();

      if (_gotUpdate) {
        Future.delayed(Duration.zero, () => _showUpdateAlertDialog());
      } else {
        Future.delayed(const Duration(seconds: 5), () {
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
        child: Visibility(
          child: FloatingActionButton(
              onPressed: () {
                showInformationDialog(context);
              },
              child: infoIcon()),
          visible: _eventNotEnded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: InkWell(
        onTap: () {
          setEventInstanceInformation()
              .then((_) => {
                    setState(() {
                      _eventNotEnded = Event.instance?.endDate == null
                          ? false
                          : getTimeDifference(
                                  Event.instance?.endDate.seconds.toString()) >=
                              0;
                    })
                  })
              .then((value) => _checkCurrentState());
        },
        child: Container(
          margin: Constants.sideMargins,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              sizedBoxSpacing(_currentHeight),
              Center(
                child: Text(
                  Local.splashTitle,
                  style: CustomTextStyle.titleText
                      .copyWith(fontSize: _currentWidth * 0.15),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  softWrap: true,
                ),
              ),
              SizedBox(height: _currentHeight * 0.1),
              (_eventNotEnded
                  ? Text(
                      getTimeStampAsString(Event.instance!.startDate),
                      style: CustomTextStyle.defaultStyle,
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      Local.defaultDate,
                      style: CustomTextStyle.defaultStyle,
                      textAlign: TextAlign.center,
                    )),
              bottomLogo(),
              sizedBoxSpacing(_currentHeight, 0.05),
            ],
          ),
        ),
      ),
    );
  }

  void _checkCurrentState() async {
    final FireDatabase db = FireDatabase();
    final prefs = await SharedPreferences.getInstance();

    if (_eventNotEnded) {
      if (prefs.containsKey(Constants.keySharPref)) {
        String _guestCode = prefs.getString(Constants.keySharPref) ?? "";

        bool guestRegisteredToEvent =
            await db.checkCurrentGuestCode(context, _guestCode);

        if (guestRegisteredToEvent) {
          if (_eventStarted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItsTimeScreen(
                          guestCode: _guestCode,
                        )));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CountDown()));
          }
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RsvpCode()));
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const RsvpCode()));
      }
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
            ],
          );
        });
  }
}
