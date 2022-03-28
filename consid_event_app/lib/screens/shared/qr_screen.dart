import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/failed/failed_screen_scanned.dart';
import 'package:consid_event_app/screens/success/success_screen_scanned.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/fire_database.dart';

class QrScreen extends StatefulWidget {
  final String guestCode;
  const QrScreen({Key? key, required this.guestCode}) : super(key: key);
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  late StreamSubscription<QuerySnapshot<Object?>> streamSubscription;
  FireDatabase db = FireDatabase();

  void _listenToTicketChanges() {
    streamSubscription = db.getGuestTickets(widget.guestCode).listen((data) {
      streamSubscription.onData((data) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SuccessScreenScanned()));
      });
    }, onError: (error) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FailedScreenScanned()));
    });
  }

  @override
  void initState() {
    if (mounted) {
      _listenToTicketChanges();
    }
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _currentHeight * 0.1,
          ),
          Container(
            alignment: Alignment.center,
            width: _currentWidth * 0.9,
            height: _currentHeight * 0.8,
            child: QrImage(
              data: "${Constants.guestCodeTypeRef}/${widget.guestCode}",
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              size: 260.0,
            ),
          ),
        ],
      ),
    );
  }
}
