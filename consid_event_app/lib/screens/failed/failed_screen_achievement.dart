import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement_list.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FailedScreenAchievement extends StatelessWidget {
  final String title;
  const FailedScreenAchievement({Key? key, required this.title})
      : super(key: key);

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
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AchievementList()));
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
            ribbonLogo(),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  Local.achievementStr + " " + title,
                  style: CustomTextStyle.defaultStyle
                      .copyWith(fontSize: _currentWidth * 0.055),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            Center(
                child: Lottie.asset(Constants.lottieFailed,
                    width: _currentWidth * 0.7)),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            Text(
              Local.failedMessage,
              style: CustomTextStyle.defaultBoldStyle
                  .copyWith(fontSize: _currentWidth * 0.06),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Returned');
                },
                child: getGoldButtonInk(context, Local.buttonTryAgain)),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
