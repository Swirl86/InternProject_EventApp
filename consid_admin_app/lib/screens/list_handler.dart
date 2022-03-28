import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:admin_app/widget/list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

void main() => runApp(const ListHandler());

class ListHandler extends StatefulWidget {
  const ListHandler({Key? key}) : super(key: key);

  @override
  _ListHandlerState createState() => _ListHandlerState();
}

class _ListHandlerState extends State<ListHandler> {
  TabBar get _tabBar => TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0,
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: Theme.of(context).primaryColor,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CustomColors.goldText),
        tabs: [
          chosenTab(context, LocalVar.everyoneList, false),
          chosenTab(context, LocalVar.scannedList, false),
          chosenTab(context, LocalVar.notScannedList, true),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the automatic back button
          elevation: 0, // Removes border shadow
          toolbarHeight: _screenSize.height * 0.2,
          backgroundColor: CustomColors.bgColor,

          title: Column(children: [
            backButton(context),
            defaultTextTitle(_screenSize, LocalVar.participants.toUpperCase()),
            StreamBuilder<QuerySnapshot>(
              stream: db.getAllClaimedInvites(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return showAlertDialog(
                      context, Constants.somethingWentWrong)();
                } else if (snapshot.hasData) {
                  int guestsCheckedIn = 0;

                  // Check how many guests that are checked in
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DocumentSnapshot data = snapshot.data!.docs[i];
                    if (data['checked_in']) guestsCheckedIn++;
                  }

                  return Column(children: [
                    SizedBox(height: _screenSize.height * 0.01),
                    Center(
                        child: Text(
                            "$guestsCheckedIn ${LocalVar.of} ${snapshot.data!.docs.length.toString()} ${LocalVar.guestCheckIn}",
                            style: CustomTextStyle.defaultStyle.copyWith(
                                fontSize: _screenSize.width * 0.065,
                                fontWeight: FontWeight.bold))),
                  ]);
                } else {
                  return loadingSpinner();
                }
              },
            ),
          ]),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: _screenSize.width * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.tabUnchosenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _tabBar,
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ListWidget(listType: "Everyone"),
            ListWidget(listType: "Scanned"),
            ListWidget(listType: "notScanned"),
          ],
        ),
      ),
    );
  }
}
