import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/widget/tickets_widget.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class TicketsList extends StatefulWidget {
  const TicketsList({Key? key}) : super(key: key);

  @override
  _TicketsListState createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  FireDatabase db = FireDatabase();
  String _guestCode = Constants.somethingWentWrong;

  void _getGuestCode() {
    db.getCurrentState().then((localStateCode) => setState(() {
          _guestCode = localStateCode!;
        }));
  }

  @override
  void initState() {
    _getGuestCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: backArrowIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: StreamBuilder<QuerySnapshot>(
        stream: db.getGuestTickets(_guestCode),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return showAlertDialog(
                context, Constants.somethingWentWrong, Colors.red);
          } else if (snapshot.hasData) {
            return TicketWidget(snapshot: snapshot, guestCode: _guestCode);
          } else {
            return loadingSpinner(MediaQuery.of(context).size.width, 0.5);
          }
        },
      ),
    );
  }
}
