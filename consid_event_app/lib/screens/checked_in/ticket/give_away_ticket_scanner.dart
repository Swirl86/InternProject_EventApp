import 'dart:io';

import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/failed/failed_screen_scanned.dart';
import 'package:consid_event_app/services/app_permission.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class GiveAwayTicketScanner extends StatefulWidget {
  final String qrCode;
  final String type;

  const GiveAwayTicketScanner(
      {Key? key, required this.qrCode, required this.type})
      : super(key: key);

  @override
  _GiveAwayTicketScannerState createState() => _GiveAwayTicketScannerState();
}

class _GiveAwayTicketScannerState extends State<GiveAwayTicketScanner>
    with WidgetsBindingObserver {
  FireDatabase db = FireDatabase();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  bool showFlashOn = false;

  late AppPermission permission;

  @override
  void reassemble() {
    WidgetsBinding.instance?.addObserver(this);
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.removeObserver(this);
    super.initState();
  }

  void _onPermissionSet(QRViewController controller, bool hasBeenAccepted) {
    if (!hasBeenAccepted) {
      permission.displayDialogPermission();
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    permission = AppPermission(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      backgroundColor: CustomColors.bgColor,
      body: Column(children: [
        SizedBox(
          height: _currentHeight * 0.15,
        ),
        Center(
          child: Text(
            Local.scanGuestQRTitle,
            style: CustomTextStyle.mediumTitleText
                .copyWith(fontSize: _currentWidth * 0.1),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: _currentHeight * 0.05,
        ),
        getFlashButton(),
        Expanded(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                onPermissionSet: _onPermissionSet,
                overlay: getQrScannerOverlayShape(_currentWidth)),
          ),
        ))
      ]),
    );
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
      //Parts result order = guestCode/ticketcode
      var parts = widget.qrCode.split('/');
      final String _currentGuestCode = parts[0];
      final String _ticketCode = parts[1];

      //Result order = type/guestCode
      var _scannedResult = result!.code!.split('/');
      String _scanType = _scannedResult[0];
      String _scannedGuestCode = _scannedResult[1];

      if (_scanType == Constants.guestCodeTypeRef) {
        db.giveAwayTicket(context, _currentGuestCode, _scannedGuestCode,
            _ticketCode, widget.type);
        qrController!.stopCamera();
      } else {
        final returned = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FailedScreenScanned()));

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
