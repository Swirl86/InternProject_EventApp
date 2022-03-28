import 'dart:io';

import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

class ListInvites extends StatefulWidget {
  const ListInvites({Key? key}) : super(key: key);

  @override
  _ListInvitesState createState() => _ListInvitesState();
}

class _ListInvitesState extends State<ListInvites> {
  final AuthService _authService = AuthService();
  final User? user = _firebaseAuth.currentUser;

  final _scrollController = ScrollController();

  // Strings & models
  String inviteCodeEntered = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    // CSV list
    List<List<dynamic>> rows = <List<dynamic>>[];

    // Definition of column
    List<String> row = <String>[];
    row.add("InviteCode");
    rows.add(row);

    return Scaffold(
        backgroundColor: CustomColors.bgColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: _screenSize.width * 0.09,
          ),
        ),
        body: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                    margin: defaultPageMargins(context),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: _screenSize.height * 0.04),
                          defaultTextTitle(
                              _screenSize,
                              LocalVar.unusedInvites.toUpperCase(),
                              _screenSize.width * 0.08),
                          SizedBox(height: _screenSize.height * 0.01),
                          defaultTextButtonWithIcon(
                            context,
                            Icons.download,
                            LocalVar.downloadCsv.toUpperCase(),
                            () {
                              runSaveToCSV(context, rows);
                            },
                            _screenSize.width * 0.07,
                            _screenSize.width * 0.05,
                          ),
                          defaultDivider(),
                          StreamBuilder<QuerySnapshot>(
                            stream: db.getUnusedInvites(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return showAlertDialog(
                                    context, Constants.somethingWentWrong)();
                              } else if (snapshot.hasData) {
                                return Column(children: [
                                  Column(children: [
                                    GridView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent:
                                            _screenSize.height * 0.07,
                                      ),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot data =
                                            snapshot.data!.docs[index];

                                        // Add this ID as its own row in CSV
                                        List<dynamic> row = <dynamic>[];
                                        row.add(data.id);
                                        rows.add(row);

                                        return TextButton(
                                          onPressed: () async {
                                            setState(() => {
                                                  // Empty
                                                });
                                          },
                                          child: Text(
                                            data.id,
                                            style: CustomTextStyle.defaultStyle
                                                .copyWith(
                                              fontSize:
                                                  _screenSize.width * 0.07,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                                  SizedBox(height: _screenSize.height * 0.02),
                                ]);
                              } else {
                                return loadingSpinner();
                              }
                            },
                          )
                        ])))));
  }

  Future<void> runSaveToCSV(BuildContext context, List<List> rows) async {
    // Create temp file cache
    File _file = File(Directory.systemTemp.path + "/unusedInviteCodes.csv");
    //Convert list to csv and write to file as string
    _file.writeAsStringSync(
        const ListToCsvConverter().convert(rows.toSet().toList()));
    final params = SaveFileDialogParams(sourceFilePath: _file.path);
    await FlutterFileDialog.saveFile(params: params);
    _file.delete(); //Remove cached file when all is complete
  }
}
