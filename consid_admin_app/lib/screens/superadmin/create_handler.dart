import 'package:admin_app/screens/superadmin/createhandler/create_event.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'createhandler/create_achievement.dart';
import 'createhandler/create_invites.dart';
import 'createhandler/create_secret_achievements.dart';
import 'createhandler/create_tickets.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

void main() => runApp(const CreateHandler());

class CreateHandler extends StatefulWidget {
  const CreateHandler({Key? key}) : super(key: key);

  @override
  _CreateHandlerState createState() => _CreateHandlerState();
}

class _CreateHandlerState extends State<CreateHandler> {
  final int _nrOfTabs = 5;

  TabBar get _tabBar => TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0,
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: Theme.of(context).primaryColor,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CustomColors.goldText),
        tabs: [
          chosenTab(context, LocalVar.regular, false),
          chosenTab(context, LocalVar.secret, false),
          chosenTab(context, LocalVar.justTicket, false),
          chosenTab(context, LocalVar.invites, false),
          chosenTab(context, LocalVar.event, true),
          // Last one has to be true, no one else ('cause of design)
        ],
      );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: _nrOfTabs,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the automatic back button
          elevation: 0, // Removes border shadow
          toolbarHeight: _screenSize.height * 0.2,
          backgroundColor: CustomColors.bgColor,

          title: Column(children: [
            backButton(context),
            defaultTextTitle(_screenSize, LocalVar.createHandler.toUpperCase()),
            SizedBox(height: _screenSize.height * 0.01),
            Center(
                child: Text(LocalVar.pickWhat,
                    style: CustomTextStyle.defaultStyle.copyWith(
                        fontSize: _screenSize.width * 0.05,
                        fontWeight: FontWeight.bold))),
            SizedBox(height: _screenSize.height * 0.03),
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
            CreateAchievement(),
            CreateSecretAchievement(),
            CreateTickets(),
            CreateInvites(),
            CreateEvent(),
          ],
        ),
      ),
    );
  }
}
