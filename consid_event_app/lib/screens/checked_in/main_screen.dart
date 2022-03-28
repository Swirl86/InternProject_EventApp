import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/screens/checked_in/achievement/scanner.dart';
import 'package:consid_event_app/screens/checked_in/achievement_list.dart';
import 'package:consid_event_app/screens/checked_in/leader_board_list.dart';
import 'package:consid_event_app/screens/checked_in/tickets_list.dart';
import 'package:consid_event_app/screens/shared/qr_screen.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../reusables/logos.dart';
import '../../reusables/reusables.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FireDatabase db = FireDatabase();
  String _guestCode = Constants.somethingWentWrong;
  String _name = Constants.empty;

  void _getCurrentState() {
    db.getCurrentState().then(
        (localStateCode) => setState(() {
              _guestCode = localStateCode!;
              db.getGuestName(context, localStateCode).then(
                  (value) => setState(() {
                        _name = value;
                      }), onError: ((_) {
                showAlertDialog(
                    context, Constants.somethingWentWrong, Colors.red);
              }));
            }), onError: ((_) {
      showAlertDialog(context, Constants.somethingWentWrong, Colors.red);
    }));
  }

  @override
  void initState() {
    _getCurrentState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        margin: Constants.sideMargins,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              sizedBoxSpacing(_currentHeight),
              Column(
                children: <Widget>[
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 10.0,
                    runSpacing: 20,
                    children: [
                      Text(
                        _name.toUpperCase(),
                        style: CustomTextStyle.mediumTitleText,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  sizedBoxSpacing(_currentHeight, 0.03),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  sizedBoxSpacing(_currentHeight, 0.08),
                  _getAchievementWidget(),
                  sizedBoxSpacing(_currentHeight, 0.07),
                  _getTicketWidget(),
                ],
              ),
              sizedBoxSpacing(_currentHeight, 0.06),
              _getScannerWidget(),
              sizedBoxSpacing(_currentHeight, 0.04),
              _getLeaderboardWidget(),
              sizedBoxSpacing(_currentHeight, 0.07),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrScreen(
                                      guestCode: _guestCode,
                                    )));
                      },
                      child: QrImage(
                        data: "${Constants.guestCodeTypeRef}/$_guestCode",
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: _currentHeight * 0.15,
                      ),
                    ),
                    bottomLogo()
                  ]),
              sizedBoxSpacing(_currentHeight, 0.05),
            ],
          ),
        ),
      ),
    );
  }

  _getAchievementWidget() {
    var _currentWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AchievementList()));
      },
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 10.0,
            runSpacing: 20,
            children: [
              SizedBox(
                width: _currentWidth * 0.45,
                child: achievementsLogo(),
              ),
              Text(Local.achievmentsTitle,
                  style: CustomTextStyle.mediumTitleText
                      .copyWith(fontSize: _currentWidth * 0.1)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: db.getGuestAchievements(_guestCode),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return showAlertDialog(
                        context, Constants.somethingWentWrong, Colors.red);
                  } else if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        style: CustomTextStyle.boldGradientTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return loadingSpinner(_currentWidth, 0.08);
                  }
                },
              ),
              const Text(Local.ofStr, style: CustomTextStyle.defaultStyle),
              StreamBuilder<QuerySnapshot>(
                stream: db.getEventAchievements(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return showAlertDialog(
                        context, Constants.somethingWentWrong, Colors.red);
                  } else if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        style: CustomTextStyle.boldGradientTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return loadingSpinner(_currentWidth, 0.08);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getTicketWidget() {
    final _currentWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TicketsList()));
      },
      child: Column(
        children: [
          ticketLogo(),
          Text(Local.ticketsTitle,
              style: CustomTextStyle.mediumTitleText
                  .copyWith(fontSize: _currentWidth * 0.11)),
          StreamBuilder<QuerySnapshot>(
            stream: db.getNumberOfAvailableTickets(_guestCode),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return showAlertDialog(
                    context, Constants.somethingWentWrong, Colors.red);
              } else if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    snapshot.data!.docs.length.toString(),
                    style: CustomTextStyle.boldGradientTextStyle,
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return loadingSpinner(_currentWidth, 0.06);
              }
            },
          ),
        ],
      ),
    );
  }

  _getScannerWidget() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 15),
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Scanner()));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.qr_code_scanner,
                color: CustomColors.goldEdge,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Local.scanQRButtonTitle,
                style: CustomTextStyle.defaultBoldStyle,
              )
            ],
          )),
    );
  }

  _getLeaderboardWidget() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 15),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LeaderBoardList()));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.poll_outlined,
                color: CustomColors.goldEdge,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Local.leaderBoardTitle,
                style: CustomTextStyle.defaultBoldStyle,
              )
            ],
          )),
    );
  }
}
