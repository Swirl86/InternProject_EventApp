import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/widget/list_user_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

List<ScrollController> _scrollControllerList = [];

class ListWidget extends StatefulWidget {
  final String listType;
  const ListWidget({Key? key, required this.listType}) : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final AuthService _authService = AuthService();

  final User? user = _firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _scrollControllerList.add(ScrollController());

    return Scaffold(
        backgroundColor: CustomColors.bgColor,
        body: Scrollbar(
            controller: _scrollControllerList.last,
            isAlwaysShown: true,
            child: SingleChildScrollView(
                controller: _scrollControllerList.last,
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: handleDbConnection(widget.listType),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return showAlertDialog(
                            context, Constants.somethingWentWrong)();
                      } else if (snapshot.hasData) {
                        return Column(children: [
                          SizedBox(height: _screenSize.height * 0.015),
                          UserWidget(
                              snapshot: snapshot, widgetType: widget.listType),
                          SizedBox(height: _screenSize.height * 0.015),
                        ]);
                      } else {
                        return loadingSpinner();
                      }
                    },
                  ),
                ]))));
  }

  Stream<QuerySnapshot<Object?>> handleDbConnection(String listType) {
    switch (listType) {
      case 'Scanned':
        return db.getCheckedIn();
      case 'notScanned':
        return db.getNotCheckedIn();
      default:
        return db.getAllClaimedInvites();
    }
  }
}
