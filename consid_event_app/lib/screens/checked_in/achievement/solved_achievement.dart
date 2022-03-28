import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/achievement_list.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

class SolvedAchievement extends StatelessWidget {
  final String solvedDate;
  final Map<String, dynamic> achievement;
  const SolvedAchievement(
      {Key? key, required this.solvedDate, required this.achievement})
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
          children: [
            SizedBox(
              height: _currentHeight * 0.15,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              achievementsLogo(),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Text(
                  achievement[Constants.taskTitleRef],
                  style: CustomTextStyle.defaultStyle
                      .copyWith(fontSize: _currentWidth * 0.055),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ]),
            SizedBox(
              height: _currentHeight * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                achievement[Constants.taskDescriptionRef],
                style: CustomTextStyle.defaultStyle,
                maxLines: 10,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _currentWidth * 0.15),
              child: Column(
                children: [
                  const Text(
                    Local.achievedStr,
                    style: CustomTextStyle.defaultStyle,
                  ),
                  SizedBox(
                    height: _currentHeight * 0.02,
                  ),
                  Text(
                    solvedDate,
                    style: CustomTextStyle.defaultBoldStyle,
                  ),
                  SizedBox(
                    height: _currentHeight * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
