import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/models/secret.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/screens/checked_in/achievement/achievement_types/secret_type.dart';
import 'package:consid_event_app/screens/checked_in/achievement/solved_achievement.dart';
import 'package:consid_event_app/screens/checked_in/achievement/todo_achievements.dart';
import 'package:consid_event_app/theme/custom_colors.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

dynamic getAchievements(BuildContext context, String achievementId,
    Map<String, dynamic> achievement, String guestCode, String solvedDate) {
  if (solvedDate.isNotEmpty) {
    return getCompletedWidget(context, achievement, solvedDate);
  } else {
    return getUnCompletedWidget(context, achievementId, achievement, guestCode);
  }
}

dynamic getSecretAchievements(
    BuildContext context, Map<String, dynamic> achievement, String solvedDate) {
  final _currentWidth = MediaQuery.of(context).size.width;
  final _currentHeight = MediaQuery.of(context).size.height;

  String title = "";
  switch (achievement[Constants.typeTriggerRef]) {
    case Constants.achievementsRef:
      title = Local.achievementsDone;
      break;
    case Constants.ticketsRef:
      title = Local.ticketsUsed;
      break;
    case Constants.scannedRef:
      title = Local.scannedStr;
      break;
    default:
  }

  return InkWell(
    onTap: () {
      Secret secret = Secret(
          trigger: achievement[Constants.typeTriggerRef],
          percent: achievement[Constants.typePercentRef],
          solved: solvedDate);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecretType(achievement: secret)));
    },
    // child: SecretConfettiWidget(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              secretAchievementLogo(context),
              Container(
                  margin: EdgeInsets.only(bottom: _currentHeight * 0.005),
                  child: RichText(
                    text: TextSpan(
                      text: achievement[Constants.typePercentRef],
                      style: CustomTextStyle.defaultBoldStyle.copyWith(
                          fontSize: _currentWidth * 0.05,
                          color: CustomColors.bgColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: title == Local.scannedStr
                                ? Constants.empty
                                : Local.percentAchiev,
                            style: CustomTextStyle.defaultBoldStyle.copyWith(
                                fontSize: _currentWidth * 0.035,
                                color: CustomColors.bgColor)),
                      ],
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: _currentHeight * 0.14),
                child: Center(
                  child: Text(
                    title,
                    overflow: TextOverflow.fade,
                    style: CustomTextStyle.defaultStyle
                        .copyWith(fontSize: _currentWidth * 0.045),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    //),
  );
}

getCompletedWidget(
    BuildContext context, Map<String, dynamic> achievement, String solvedDate) {
  var _currentSize = MediaQuery.of(context).size;
  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SolvedAchievement(
                    solvedDate: solvedDate, achievement: achievement)));
      },
      child: Column(
        children: [
          SizedBox(
            height: _currentSize.height * 0.065,
            child: achievementsLogo(),
          ),
          SizedBox(
            height: _currentSize.height * 0.02,
          ),
          Text(
            Local.achievementStr + " " + achievement[Constants.taskTitleRef],
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: _currentSize.width * 0.045),
            textAlign: TextAlign.center,
          ),
        ],
      ));
}

getUnCompletedWidget(BuildContext context, String achievementId,
    Map<String, dynamic> achievement, String guestCode) {
  var _currentSize = MediaQuery.of(context).size;
  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TodoAchievements(
                    guestCode: guestCode,
                    achievementId: achievementId,
                    achievement: achievement)));
      },
      child: Column(
        children: [
          SizedBox(
            height: _currentSize.height * 0.065,
            child: inactiveAchievementsLogo(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            Local.achievementStr + " " + achievement[Constants.taskTitleRef],
            maxLines: 3,
            overflow: TextOverflow.fade,
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: _currentSize.width * 0.045),
            textAlign: TextAlign.center,
          ),
        ],
      ));
}
