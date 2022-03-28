import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../reusables/reusables.dart';

class FailedPermission extends StatelessWidget {
  const FailedPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _currentHeight * 0.15,
            ),
            Center(
                child: Lottie.asset(Constants.lottiePermission,
                    width: _currentWidth * 0.7)),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            const Text(
              Local.permissionUsage,
              style: CustomTextStyle.defaultBoldStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: getGoldButtonInk(context, Local.buttonTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
