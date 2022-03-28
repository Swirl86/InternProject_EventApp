import 'dart:async';
import 'dart:io';

import 'package:admin_app/screens/manual_handler.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/theme/custom_colors.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firebase db = Firebase();

class Scanning extends StatefulWidget {
  const Scanning({Key? key}) : super(key: key);

  @override
  ScanningState createState() => ScanningState();
}

class ScanningState extends State<Scanning> {
  // References
  final AuthService _authService = AuthService();
  final User? user = _firebaseAuth.currentUser;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  bool _showSuccess = false;
  bool _showFailure = false;
  bool showFlashOn = true;
  var userName = "";
  var ticketType = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // Depending on scanType, check with different dbHandlers
        if (scanData.code!.contains("ticket/")) {
          scanHandleTicket(scanData.code);
        } else if (scanData.code!.contains("guest_code/")) {
          scanHandleCheckin(scanData.code);
        } else {
          showFailure();
        }
      });
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(children: [
        SizedBox(height: _screenSize.height * 0.06),
        backButton(context),
        defaultTextTitle(_screenSize, LocalVar.scan.toUpperCase()),
        SizedBox(height: _screenSize.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: toggleFlash(context),
            ),
            Row(
              children: [
                Text(LocalVar.manually.toUpperCase(),
                    style: CustomTextStyle.defaultStyle
                        .copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                    iconSize: _screenSize.width * 0.12,
                    color: CustomColors.goldText,
                    icon: Stack(children: const [
                      Icon(Icons.qr_code_scanner_rounded),
                      Icon(Icons.close)
                    ]),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManualHandler()));
                    }),
              ],
            ),
          ],
        ),
        SizedBox(height: _screenSize.height * 0.01),
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      borderColor: CustomColors.goldEdge,
                      borderWidth: 12,
                      cutOutSize: _screenSize.width * 0.95,
                      borderLength: 25)),
              Visibility(
                visible: _showSuccess,
                child: Lottie.asset(
                  'assets/success.json',
                  width: 270,
                ),
              ),
              Visibility(
                visible: _showSuccess,
                child: Positioned(
                  bottom: _screenSize.height * 0.175,
                  child: Center(
                      child: Text(
                          (ticketType.isNotEmpty)
                              ? (userName +
                                  LocalVar.s +
                                  ticketType +
                                  LocalVar.scanned)
                              : (ticketType + userName + LocalVar.checkIn),
                          style: CustomTextStyle.defaultStyle
                              .copyWith(fontWeight: FontWeight.bold))),
                ),
              ),
              Visibility(
                visible: _showFailure,
                child: Lottie.asset(
                  'assets/failed.json',
                  width: 320,
                ),
              ),
              Visibility(
                visible: _showFailure,
                child: Positioned(
                    bottom: (_screenSize.width * 0.3),
                    child: Center(
                        child: Text(LocalVar.notExpected,
                            style: CustomTextStyle.defaultStyle
                                .copyWith(fontWeight: FontWeight.bold)))),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /* 
  Lottie handling
  */

  showSuccess(String _inputName, [String _ticketType = ""]) {
    _showSuccess = true;
    userName = _inputName;
    ticketType = _ticketType;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSuccess = false;
      });
    });
  }

  showFailure() {
    _showFailure = true;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showFailure = false;
      });
    });
  }

  toggleFlash(context) {
    return IconButton(
        iconSize: MediaQuery.of(context).size.width * 0.105,
        color: CustomColors.goldText,
        icon: showFlashOn
            ? const Icon(Icons.flash_off)
            : const Icon(Icons.flash_on),
        onPressed: () async {
          await qrController?.toggleFlash();
          setState(() {
            showFlashOn = !showFlashOn;
          });
        });
  }

/* 
  These seems to need to be here, otherwise Lottie stops functioning 
*/
  scanHandleCheckin(String? userID) async {
    var _userId = userID!.split("/")[1];
    var _userName = "";

    var chosenUser =
        FirebaseFirestore.instance.collection('guests').doc(_userId);

    await chosenUser
        .get()
        .then((_value) => {_userName = _value['name']})
        .catchError((error) => {showFailure()});

    await chosenUser
        .update({
          'checked_in': true,
        })
        .then((_) => {showSuccess(_userName)})
        .catchError((error) => {showFailure()});
  }

  scanHandleTicket(String? userAndTicketId) async {
    var _userId = userAndTicketId!.split("/")[1];
    var _ticketId = userAndTicketId.split("/")[2];
    var _ticketType = "";
    var _userName = "";

    var chosenUser =
        FirebaseFirestore.instance.collection('guests').doc(_userId);

    await chosenUser
        .get()
        .then((_value) => {
              _userName = _value['name'],
            })
        .catchError((error) => {showFailure()});

    var userTicket = chosenUser.collection('tickets').doc(_ticketId);

    await userTicket
        .get()
        .then((_value) =>
            {_ticketType = _value['type'], showSuccess(_userName, _ticketType)})
        .catchError((error) => {showFailure()});

    await userTicket
        .update({
          'used': true,
        })
        .then((_) => {showSuccess(_userName, _ticketType)})
        .catchError((error) => {showFailure()});
  }
  // ------ Lottie area ending --------
}
