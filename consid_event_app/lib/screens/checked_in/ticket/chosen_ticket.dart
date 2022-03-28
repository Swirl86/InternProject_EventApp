import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/ticket/give_away_ticket_scanner.dart';
import 'package:consid_event_app/screens/checked_in/tickets_list.dart';
import 'package:consid_event_app/screens/failed/failed_screen_ticket.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChosenTicket extends StatefulWidget {
  final String qrCode;

  const ChosenTicket({Key? key, required this.qrCode}) : super(key: key);

  @override
  _ChosenTicketState createState() => _ChosenTicketState();
}

class _ChosenTicketState extends State<ChosenTicket> {
  late StreamSubscription<QuerySnapshot<Object?>> streamSubscription;
  FireDatabase db = FireDatabase();
  String _type = "Ticket Type";

  void _listenOnTicketStatus() {
    var parts = widget.qrCode.split('/');
    final String _guestCode = parts[0];
    final String _ticketCode = parts[1];

    streamSubscription =
        db.getGuestSpecificTicket(_guestCode, _ticketCode).listen((data) {
      setState(() {
        _type = data.docs[0][Constants.typeRef];
      });
      streamSubscription.onData((data) {
        streamSubscription.cancel();
        db.checkIfSecretAchievementTrigger(
            context, _guestCode, Constants.ticketsRef);
      });
    }, onError: (error) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FailedScreenTicket()));
    });
  }

  @override
  void initState() {
    _listenOnTicketStatus();
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
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => const TicketsList()));
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: _currentWidth * 0.3,
            ),
            SizedBox(
                width: _currentWidth * 0.8,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      child: Text(
                        Local.oneFree,
                        style: CustomTextStyle.titleText
                            .copyWith(fontSize: _currentWidth * 0.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: _currentWidth * 0.45),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            _type.toUpperCase(),
                            style: CustomTextStyle.titleText
                                .copyWith(fontSize: _currentWidth * 0.2),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ],
                )),
            SizedBox(
              height: _currentWidth * 0.02,
            ),
            Container(
              color: CustomColors.bgColor,
              child: QrImage(
                // Data order = type/guestCode/ticketId
                data: "${Constants.tickedTypeRef}/${widget.qrCode}",
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: _currentWidth * 0.8,
              ),
            ),
            SizedBox(
              height: _currentWidth * 0.06,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 15),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiveAwayTicketScanner(
                                qrCode: widget.qrCode, type: _type)));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mobile_screen_share_rounded,
                        color: CustomColors.goldEdge,
                        size: _currentWidth * 0.1,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Local.giveTicket,
                        style: CustomTextStyle.boldGradientTextStyle
                            .copyWith(fontSize: _currentWidth * 0.08),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
