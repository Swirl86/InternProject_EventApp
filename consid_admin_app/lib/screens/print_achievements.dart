import 'dart:typed_data';
import 'package:admin_app/models/achieve_model.dart';
import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();
ScrollController _scrollController = ScrollController();

class PrintAchieve extends StatefulWidget {
  const PrintAchieve({Key? key}) : super(key: key);

  @override
  _PrintAchieveState createState() => _PrintAchieveState();
}

class _PrintAchieveState extends State<PrintAchieve> {
  final AuthService _authService = AuthService();
  final User? user = _firebaseAuth.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
            isAlwaysShown: true,
            child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Container(
                    margin: defaultPageMargins(context),
                    child: Column(children: [
                      SizedBox(height: _screenSize.height * 0.03),
                      defaultTextTitle(
                          _screenSize, LocalVar.listScannable.toUpperCase()),
                      SizedBox(height: _screenSize.height * 0.01),
                      defaultDivider(),
                      SizedBox(height: _screenSize.height * 0.01),
                      StreamBuilder<QuerySnapshot>(
                        stream: db.getAchievementsScanQr(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return showAlertDialog(
                                context, Constants.somethingWentWrong)();
                          } else if (snapshot.hasData) {
                            return Column(children: [
                              Column(children: [
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data!.docs[index];

                                      return ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 30.0,
                                                  vertical: 0.0),
                                          visualDensity: const VisualDensity(
                                              horizontal: 0, vertical: -4),
                                          title: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextButton(
                                                  onPressed: () async {
                                                    AchieveModel
                                                        thisAchievement =
                                                        AchieveModel(
                                                      qrCode: data['qr_code'],
                                                      description: data[
                                                          'task_description'],
                                                      title: data['task_title'],
                                                      type: data['task_type'],
                                                    );

                                                    await Printing.layoutPdf(
                                                        onLayout: (format) =>
                                                            _generatePdf(format,
                                                                thisAchievement));
                                                  },
                                                  child: Row(children: [
                                                    const Icon(
                                                      Icons.add_to_home_screen,
                                                      color:
                                                          CustomColors.goldText,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            _screenSize.width *
                                                                0.01),
                                                    Text(
                                                      data['task_title'],
                                                      style: CustomTextStyle
                                                          .defaultStyle
                                                          .copyWith(
                                                        fontSize:
                                                            _screenSize.width *
                                                                0.05,
                                                      ),
                                                    ),
                                                  ]))));
                                    },
                                  ),
                                ),
                              ]),
                              SizedBox(height: _screenSize.height * 0.02),
                            ]);
                          } else {
                            return loadingSpinner();
                          }
                        },
                      ),
                    ])))));
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, AchieveModel achievementInfo) async {
    final pdf = pw.Document();

    var imageProvider = NetworkImage(await db.getImageUrl("pdflogo.png"));
    final image = await flutterImageProvider(imageProvider);

    pdf.addPage(pw.Page(
        pageFormat: format.copyWith(
            marginLeft: 1.0 * PdfPageFormat.cm,
            marginRight: 1.0 * PdfPageFormat.cm),
        build: (context) => pw.Center(
              child: pw.Column(
                children: [
                  pw.SizedBox(height: format.availableHeight * 0.02),
                  pw.Container(
                    width: format.width * 0.5,
                    child: pw.Image(image, width: format.availableWidth * 0.7),
                  ),
                  pw.SizedBox(height: format.availableHeight * 0.02),
                  pw.Column(children: [
                    pw.Text(achievementInfo.title,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                            fontSize: 1.4 * PdfPageFormat.cm)),
                    pw.SizedBox(height: format.availableHeight * 0.02),
                    pw.Text(achievementInfo.description,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                            fontSize: 0.8 * PdfPageFormat.cm)),
                  ]),
                  pw.SizedBox(height: format.availableHeight * 0.05),
                  pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"), //Black
                      barcode: pw.Barcode.qrCode(),
                      data: achievementInfo.qrCode,
                      height: format.availableWidth * 0.55,
                      width: format.availableWidth * 0.55),
                ],
              ),
            )));

    return pdf.save();
  }
}
