import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/achievement.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement/solved_achievement.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:consid_event_app/widget/top_confetti_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreenAchievement extends StatelessWidget {
  final Achievement achievement;
  const SuccessScreenAchievement({Key? key, required this.achievement})
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
              Map<String, dynamic> map = <String, dynamic>{};
              map[Constants.taskTitleRef] = achievement.title;
              map[Constants.taskDescriptionRef] = achievement.description;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SolvedAchievement(
                          solvedDate: getTimeStampAsString(achievement.solved),
                          achievement: map)));
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
              height: _currentHeight * 0.15,
            ),
            ribbonLogo(),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  Local.achievementStr + " " + achievement.title,
                  style: CustomTextStyle.defaultStyle
                      .copyWith(fontSize: _currentWidth * 0.055),
                  textAlign: TextAlign.center,
                )),
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
