import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/guest.dart';
import 'package:consid_event_app/widget/leader_board.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

class LeaderBoardList extends StatefulWidget {
  const LeaderBoardList({Key? key}) : super(key: key);

  @override
  _LeaderBoardListState createState() => _LeaderBoardListState();
}

class _LeaderBoardListState extends State<LeaderBoardList> {
  FireDatabase db = FireDatabase();
  List<Guest?>? guestList = <Guest>[];
  bool _isLoading = true;

  void _getLeaderBoardList() {
    db.getEventLeaderBoard().then((guests) {
      guests.removeWhere((item) => item == null);
      for (int i = 0; i < guests.length; i++) {
        Guest? data = guests[i] as Guest?;
        if (data!.name.isNotEmpty && data.completedAchievments != 0) {
          guestList!.add(data);
        }
      }

      guestList!.sort((a, b) {
        if (a!.completedAchievments == b!.completedAchievments) {
          return b.lastAchievement.compareTo(a.lastAchievement);
        } else {
          return a.completedAchievments.compareTo(b.completedAchievments);
        }
      });

      setState(() {
        guestList =
            guestList!.reversed.take(Constants.maxNumberInTopList).toList();
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      showAlertDialog(context, Constants.somethingWentWrong, Colors.red);
    });
  }

  void refreshList() {
    _isLoading = true;
    guestList = <Guest>[];
    _getLeaderBoardList();
  }

  @override
  void initState() {
    _getLeaderBoardList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoard lb = LeaderBoard(context);
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {},
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: backArrowIcon()),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {},
                child: InkWell(
                  onTap: () {
                    refreshList();
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _currentHeight * 0.15,
            ),
            Center(
              child: Text(
                Local.leaderBoardTitle,
                style: CustomTextStyle.mediumTitleText
                    .copyWith(fontSize: _currentWidth * 0.12),
                maxLines: 4,
                overflow: TextOverflow.fade,
              ),
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            _isLoading
                ? SizedBox(
                    height: 200,
                    child: Transform.scale(
                      scale: 2.5,
                      child: loadingSpinner(
                          MediaQuery.of(context).size.width, 0.1),
                    ),
                  )
                : Column(children: [
                    SizedBox(
                        width: _currentWidth * 0.95,
                        child: Row(
                          children: [
                            SizedBox(width: _currentWidth * 0.12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(Local.lbHeaderPlace,
                                    style: CustomTextStyle.defaultStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.035)),
                              ],
                            ),
                            SizedBox(width: _currentWidth * 0.07),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(Local.lbHeaderName,
                                    style: CustomTextStyle.defaultStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.035)),
                              ],
                            ),
                            SizedBox(width: _currentWidth * 0.40),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Local.lbHeaderScore,
                                    style: CustomTextStyle.defaultStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.035)),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: _currentWidth * 0.04,
                    ),
                    SizedBox(
                      width: _currentWidth * 0.8,
                      child: Table(
                          // border: TableBorder.all(),
                          columnWidths: const {
                            0: FractionColumnWidth(.05),
                            1: FractionColumnWidth(.05),
                            2: FractionColumnWidth(.48),
                            3: FractionColumnWidth(.13)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: List<TableRow>.generate(guestList!.length,
                              (index) {
                            Guest? data = guestList![index];
                            return lb.getLeaderBoard(data, (index + 1));
                          }, growable: false)),
                    ),
                    SizedBox(
                      height: _currentHeight * 0.05,
                    ),
                  ])
          ],
        ),
      ),
    );
  }
}
