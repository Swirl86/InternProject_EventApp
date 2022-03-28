import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/secret.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement_list.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SecretType extends StatelessWidget {
  final Secret achievement;
  const SecretType({Key? key, required this.achievement}) : super(key: key);

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
              Navigator.pushReplacement(
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
              height: _currentHeight * 0.1,
            ),
            _getTriggerLottie(
                achievement.trigger, _currentHeight, _currentWidth),
            SizedBox(
              height: _currentHeight * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  _getTriggerLottie(
      String trigger, double _currentHeight, double _currentWidth) {
    if (trigger == Constants.achievementsRef) {
      return _getAchievementTriggerLottie(_currentHeight, _currentWidth);
    } else if (trigger == Constants.ticketsRef) {
      return _getTicketTriggerLottie(_currentHeight, _currentWidth);
    } else if (trigger == Constants.scannedRef) {
      return _getScanTriggerLottie(_currentHeight, _currentWidth);
    }
  }

  _getAchievementTriggerLottie(
    double _currentHeight,
    double _currentWidth,
  ) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            child: Lottie.asset(Constants.lottieSecretAchievementRef1,
                height: _currentHeight * 0.4)),
        Stack(
          children: [
            secretAchievementRibbonLogo(),
            Container(
              margin: EdgeInsets.only(top: _currentWidth * 0.065),
              alignment: Alignment.topCenter,
              child: _getTextContainerWiget(
                  _currentHeight, _currentWidth, Local.achievementsDone),
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
          ],
        )
      ]),
    );
  }

  _getTicketTriggerLottie(double _currentHeight, double _currentWidth) {
    return Stack(
      children: [
        secretAchievementRibbonLogo(),
        Container(
            margin: EdgeInsets.only(top: _currentHeight * 0.05),
            alignment: Alignment.topCenter,
            child: Lottie.asset(Constants.lottieSecretAchievementRef2,
                height: _currentHeight * 0.9)),
        Container(
          margin: EdgeInsets.only(top: _currentWidth * 0.065),
          child: _getTextContainerWiget(
              _currentHeight, _currentWidth, Local.ticketsUsed),
        ),
      ],
    );
  }

  _getTextContainerWiget(
      double _currentHeight, double _currentWidth, String title) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
            achievement.percent + Local.percentAchiev,
            style: CustomTextStyle.darkBoldGradientTextStyle
                .copyWith(fontSize: _currentWidth * 0.13),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _currentHeight * 0.02,
          ),
          Text(
            Local.ofStr,
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: _currentWidth * 0.07),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _currentHeight * 0.02,
          ),
          Text(
            title,
            overflow: TextOverflow.fade,
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: _currentWidth * 0.08),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _currentHeight * 0.03,
          ),
          Text(
            achievement.solved,
            style: CustomTextStyle.defaultStyle,
          ),
        ],
      ),
    );
  }

  _getScanTriggerLottie(double _currentHeight, double _currentWidth) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Lottie.asset(Constants.lottieSecretAchievementRef3,
                height: _currentHeight * 0.5),
            Text(
              Local.scannedStr,
              style: CustomTextStyle.boldGradientTextStyle
                  .copyWith(fontSize: _currentWidth * 0.15),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _currentHeight * 0.02,
            ),
            Text(
              achievement.percent + Local.peopleStr,
              style: CustomTextStyle.boldGradientTextStyle
                  .copyWith(fontSize: _currentWidth * 0.1),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _currentHeight * 0.02,
            ),
            Text(
              Local.socialStr,
              style: CustomTextStyle.defaultStyle
                  .copyWith(fontSize: _currentWidth * 0.08),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _currentHeight * 0.04,
            ),
            Text(
              achievement.solved,
              style: CustomTextStyle.defaultStyle,
            ),
            SizedBox(
              height: _currentHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
