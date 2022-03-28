import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/main_screen.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:consid_event_app/widget/top_confetti_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreenScanned extends StatelessWidget {
  const SuccessScreenScanned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: TopConfettiWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _currentHeight * 0.2,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                Local.successScanMsg,
                style: CustomTextStyle.defaultStyle
                    .copyWith(fontSize: _currentWidth * 0.055),
              ),
            ),
            SizedBox(
              height: _currentHeight * 0.1,
            ),
            Center(
                child: Lottie.asset(Constants.lottieSuccess,
                    width: _currentWidth * 0.7)),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
