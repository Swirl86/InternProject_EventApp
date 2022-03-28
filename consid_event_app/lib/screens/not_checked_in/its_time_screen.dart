import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/welcome_splach_screen.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ItsTimeScreen extends StatefulWidget {
  final String guestCode;
  const ItsTimeScreen({Key? key, required this.guestCode}) : super(key: key);

  @override
  _ItsTimeScreenState createState() => _ItsTimeScreenState();
}

class _ItsTimeScreenState extends State<ItsTimeScreen> {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      streamSubscription;
  FireDatabase db = FireDatabase();
  bool _isCheckedIn = false;

  void _startListener() {
    streamSubscription =
        db.getGuestQuerySnapshot(widget.guestCode).listen((data) {
      setState(() {
        _isCheckedIn = data.get(Constants.checkedInRef);
      });
      if (_isCheckedIn) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const WelcomeSplashScreen()));
      }
    }, onError: (error) {
      showAlertDialog(context, Local.noDataInFieldErrorMsg, Colors.red);
    });
  }

  @override
  void initState() {
    _startListener();
    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: Constants.sideMargins,
        alignment: FractionalOffset.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxSpacing(_currentHeight),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 20,
              runSpacing: 30,
              children: [
                Text(
                  Local.itsTimeTitle.toUpperCase(),
                  style: CustomTextStyle.titleText
                      .copyWith(fontSize: _currentWidth * 0.15),
                  textAlign: TextAlign.center,
                ),
                QrImage(
                  data: "${Constants.guestCodeTypeRef}/${widget.guestCode}",
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: _currentWidth * 0.65,
                ),
                Text(
                  Local.itsTimeSubTitle,
                  style: CustomTextStyle.defaultBoldStyle
                      .copyWith(fontSize: _currentWidth * 0.06),
                  textAlign: TextAlign.center,
                ),
                Text(
                  Local.itsTimeInformation,
                  style: CustomTextStyle.defaultStyle
                      .copyWith(fontSize: _currentWidth * 0.055),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            sizedBoxSpacing(_currentHeight, 0.02),
            bottomLogo(),
            sizedBoxSpacing(_currentHeight, 0.02),
          ],
        ),
      ),
    );
  }
}
