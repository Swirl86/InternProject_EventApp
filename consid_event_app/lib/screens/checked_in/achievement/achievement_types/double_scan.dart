import 'dart:io';

import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement/double_scan_qr_code.dart';
import 'package:consid_event_app/screens/failed/failed_screen_achievement.dart';
import 'package:consid_event_app/services/app_permission.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../achievement_list.dart';

class DoubleScan extends StatefulWidget {
  final String guestCode;
  final String achievementId;
  final Map<String, dynamic> achievement;
  const DoubleScan(
      {Key? key,
      required this.guestCode,
      required this.achievementId,
      required this.achievement})
      : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<DoubleScan> with WidgetsBindingObserver {
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AchievementList()));
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      backgroundColor: CustomColors.bgColor,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            height: _currentHeight * 0.15,
          ),
          Column(
            children: [
              inactiveAchievementsLogo(),
              SizedBox(
                height: _currentWidth * 0.05,
              ),
              SizedBox(
                width: _currentWidth * 0.8,
                child: Center(
                  child: Text(
                    Local.achievementStr +
                        " " +
                        widget.achievement[Constants.taskTitleRef],
                    style: CustomTextStyle.achievementUnCompletedTitleTextStyle,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: _currentHeight * 0.05,
          ),
          SizedBox(
            width: _currentWidth * 0.8,
            height: _currentWidth * 0.3,
            child: Center(
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                scrollDirection: Axis.vertical,
                child: Text(
                  widget.achievement[Constants.taskDescriptionRef],
                  style: CustomTextStyle.defaultStyle
                      .copyWith(fontSize: _currentWidth * 0.062),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: _currentHeight * 0.02,
          ),
          getFlashButton(),
          Container(
            alignment: Alignment.center,
            height: _currentHeight * 0.6,
            child: Stack(alignment: Alignment.bottomLeft, children: [
              QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  onPermissionSet: _onPermissionSet,
                  overlay: getQrScannerOverlayShape(_currentWidth)),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(children: [
                    SizedBox(
                      width: _currentWidth * 0.1,
                    ),
                    TextButton(
                      onPressed: () {
                        showAlertDialog(
                            context, Local.prompScanQrFirst, Colors.orange);
                      },
                      child: QrImage(
                        data: "Easter egg",
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: _currentWidth * 0.2,
                      ),
                    ),
                  ]),
                  Row(
                    children: [
                      SizedBox(
                        height: _currentWidth * 0.1,
                      )
                    ],
                  ),
                ],
              )
            ]),
          ),
        ]),
      ),
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
      var _scannedResult = result!.code!.split('/');
      String type = _scannedResult[0];
      if (type == Constants.guestCodeTypeRef) {
        final returned = await Navigator.push(
            context,
            //Data order = guestCode/achievementId/taskTitle
            MaterialPageRoute(
                builder: (context) => DoubleScanQr(
                    guestCode: widget.guestCode,
                    achievementId: widget.achievementId,
                    achievement: widget.achievement)));
        if (returned == 'Returned') {
          _setReturnState();
        }
      } else {
        final returned = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FailedScreenAchievement(
                    title: widget.achievement[Constants.taskTitleRef])));
        if (returned == 'Returned') {
          _setReturnState();
        }
      }
    } catch (e) {
      final returned = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FailedScreenAchievement(
                  title: widget.achievement[Constants.taskTitleRef])));
      if (returned == 'Returned') {
        _setReturnState();
      }
    }
  }

  _setReturnState() => setState(() {
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
