import 'dart:io';

import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/failed/failed_screen_achievement.dart';
import 'package:consid_event_app/screens/failed/failed_screen_scanned.dart';
import 'package:consid_event_app/services/app_permission.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  FireDatabase db = FireDatabase();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  bool showFlashOn = false;

  late AppPermission permission;

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
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    qrController?.dispose();
    super.dispose();
  }

  void _onPermissionSet(QRViewController controller, bool hasBeenAccepted) {
    if (!hasBeenAccepted) {
      permission.displayDialogPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    permission = AppPermission(context);

    return Scaffold(
        backgroundColor: CustomColors.bgColor,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: _currentHeight * 0.02),
          child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: closeIcon()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: _currentHeight * 0.2,
            ),
            Center(
              child: Text(
                Local.scanQRTitle,
                style: CustomTextStyle.titleText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            getFlashButton(),
            Container(
              alignment: Alignment.center,
              height: _currentHeight * 0.6,
              child: Container(
                alignment: Alignment.center,
                child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    onPermissionSet: _onPermissionSet,
                    overlay: getQrScannerOverlayShape(_currentWidth)),
              ),
            ),
          ]),
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController!.scannedDataStream.listen((scanData) {
      setState(() {
        qrController!.pauseCamera();
        result = scanData;
        _checkScannedValue();
      });
    }, onError: (error) {
      showAlertDialog(context, Constants.somethingWentWrong, Colors.red);
    });
  }

  _checkScannedValue() async {
    try {
      //Result order = type/guestCode/achievementId/taskTitle
      var _scannedResult = result!.code!.split('/');
      String type = _scannedResult[0];
      String guestCode = _scannedResult[1];
      String achievementId = _scannedResult[2];
      String title = _scannedResult[3];
      if (type == Constants.getScannedTypeRef ||
          type == Constants.doubleScanTypeRef) {
        db.handleScanGuestAchievement(context, achievementId, guestCode, title);
        qrController!.stopCamera();
      } else {
        final returned = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FailedScreenAchievement(title: title)));
        if (returned == 'Returned') {
          _setReturnState();
        }
      }
    } catch (e) {
      final returned = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FailedScreenScanned()));
      if (returned == 'Returned') {
        _setReturnState();
      }
    }
  }

  _setReturnState() => setState(() {
        //showAlertDialog(context, Local.wrongQrType, Colors.orange);
        result = null;
        qrController!.resumeCamera();
      });

  getFlashButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: IconButton(
          iconSize: MediaQuery.of(context).size.width * 0.10,
          color: CustomColors.goldText,
          icon: showFlashOn
              ? const Icon(Icons.flash_off)
              : const Icon(Icons.flash_on),
          onPressed: () async {
            await qrController?.toggleFlash();
            setState(() {
              showFlashOn = !showFlashOn;
            });
          }),
    );
  }
}
