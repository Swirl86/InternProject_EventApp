import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/screens/checked_in/welcome_splach_screen.dart';
import 'package:consid_event_app/screens/not_checked_in/splash_screen.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reusables/reusables.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FireDatabase db = FireDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        future: Future.wait([_getCurrentSate(), setEventInstanceInformation()]),
        builder: (BuildContext context, AsyncSnapshot<List<bool>> prefs) {
          if (prefs.hasError) {
            return showAlertDialog(
                context, Constants.somethingWentWrong, Colors.red);
          } else if (prefs.hasData) {
            bool? _activeGuestState =
                prefs.data![0]; // Guest have already registerd
            bool? _activeEventState =
                prefs.data![1]; // Event has started and not ended
            if (_activeEventState && _activeGuestState) {
              return const WelcomeSplashScreen();
            } else {
              return const SplashScreen();
            }
          } else {
            return loadingSpinner(MediaQuery.of(context).size.width, 0.5);
          }
        });
  }

  Future<bool> _getCurrentSate() async {
    bool stateValue = false;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('guestCode')) {
      bool existInCurrentEvent =
          await db.checkCurrentGuestCode(context, prefs.getString('guestCode'));
      bool checkedIn = await db.checkIfCurrentGuestIsCheckedIn(
          context, prefs.getString('guestCode'));
      if (existInCurrentEvent && checkedIn) {
        stateValue = true;
      }
    }
    return stateValue;
  }
}
