import 'dart:async';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/not_checked_in/its_time_screen.dart';
import 'package:consid_event_app/screens/shared/qr_screen.dart';
import 'package:consid_event_app/services/fire_database.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CountDown extends StatefulWidget {
  const CountDown({Key? key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  FireDatabase db = FireDatabase();
  String _guestCode = Constants.somethingWentWrong;
  bool _isLoading = true;

  Timer? _timer;
  dynamic days;
  dynamic hours;
  dynamic minutes;
  dynamic seconds;

  void _startTimer() async {
    var _dateStr = await db.getCurrentEventDateStr(context);

    if (mounted) {
      if (_dateStr != Local.tba) {
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            var n = getTimeDifference(_dateStr);
            if (n <= 0) {
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItsTimeScreen(
                            guestCode: _guestCode,
                          )));
              _isLoading = false;
            }

            _isLoading = false;
            days = n ~/ (24 * 3600).toInt();
            hours = (n % (24 * 3600) ~/ 3600).toInt();
            minutes = ((n % 3600) ~/ 60).toInt();
            seconds = (n % 60).toInt();
          });
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void refreshTimer() {
    _isLoading = true;
    _timer?.cancel();
    days = null;
    hours = null;
    minutes = null;
    seconds = null;

    _startTimer();
  }

  void _getCurrentState() async {
    db.getCurrentState().then((value) => _guestCode = value!);
  }

  @override
  void initState() {
    _getCurrentState();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    refreshTimer();
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {},
                child: InkWell(
                    onTap: () {
                      showInformationDialog(context);
                    },
                    child: infoIcon()),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: Constants.sideMargins,
        alignment: FractionalOffset.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sizedBoxSpacing(_currentHeight),
            _isLoading
                ? SizedBox(
                    height: _currentHeight * 0.2,
                    child: Transform.scale(
                      scale: 2.5,
                      child: loadingSpinner(MediaQuery.of(context).size.width),
                    ),
                  )
                : Table(
                    columnWidths: const {0: FractionColumnWidth(.5)},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _getDaysTableRow(_currentWidth),
                      _getTableRowSpacing(_currentHeight),
                      _getHoursTableRow(_currentWidth),
                      _getTableRowSpacing(_currentHeight),
                      _getMinutesTableRow(_currentWidth),
                      _getTableRowSpacing(_currentHeight),
                      _getSecondsTableRow(_currentWidth),
                    ],
                  ),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrScreen(
                                      guestCode: _guestCode,
                                    )));
                      },
                      child: QrImage(
                        data: "${Constants.guestCodeTypeRef}/$_guestCode",
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: _currentWidth * 0.24,
                      ),
                    ),
                    bottomLogo(),
                  ]),
            ),
            sizedBoxSpacing(_currentHeight, 0.05),
          ],
        ),
      ),
    );
  }

  _getDaysTableRow(double currentWidth) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              days != null ? days.toString() : Local.tba,
              style: CustomTextStyle.boldGradientTextStyleCountDown
                  .copyWith(fontSize: currentWidth * 0.15),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Local.days,
              style: CustomTextStyle.countDownTextStyle
                  .copyWith(fontSize: currentWidth * 0.052),
            ),
          ),
        ),
      ],
    );
  }

  _getHoursTableRow(double currentWidth) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              days != null ? hours.toString() : Local.tba,
              style: CustomTextStyle.boldGradientTextStyleCountDown
                  .copyWith(fontSize: currentWidth * 0.15),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Local.hours,
              style: CustomTextStyle.countDownTextStyle
                  .copyWith(fontSize: currentWidth * 0.052),
            ),
          ),
        ),
      ],
    );
  }

  _getMinutesTableRow(double currentWidth) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              days != null ? minutes.toString() : Local.tba,
              style: CustomTextStyle.boldGradientTextStyleCountDown
                  .copyWith(fontSize: currentWidth * 0.15),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Local.minutes,
              style: CustomTextStyle.countDownTextStyle
                  .copyWith(fontSize: currentWidth * 0.052),
            ),
          ),
        ),
      ],
    );
  }

  _getSecondsTableRow(double currentWidth) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              days != null ? seconds.toString() : Local.tba,
              style: CustomTextStyle.boldGradientTextStyleCountDown
                  .copyWith(fontSize: currentWidth * 0.15),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Local.seconds,
              style: CustomTextStyle.countDownTextStyle
                  .copyWith(fontSize: currentWidth * 0.052),
            ),
          ),
        ),
      ],
    );
  }

  _getTableRowSpacing(double currentHeight) {
    return TableRow(children: [
      SizedBox(height: currentHeight * 0.04),
      SizedBox(height: currentHeight * 0.04),
    ]);
  }
}
