import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/models/guest.dart';
import 'package:consid_event_app/reusables/logos.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

class LeaderBoard {
  late double _currentWidth;
  late double _currentHeight;
  late BuildContext context;

  LeaderBoard(this.context) {
    _currentWidth = MediaQuery.of(context).size.width;
    _currentHeight = MediaQuery.of(context).size.height;
  }

  getLeaderBoard(Guest? guest, int ranking) {
    switch (ranking) {
      case 1:
        return getFirstPrize(guest, ranking);
      case 2:
        return getSecondPrize(guest, ranking);
      case 3:
        return getThirdPrize(guest, ranking);
      default:
        return getDefault(guest, ranking);
    }
  }

  getFirstPrize(Guest? guest, int ranking) {
    return TableRow(children: [
      TableCell(
          // verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.bottomLeft,
        child: SizedBox(
            width: _currentWidth * 0.07,
            height: _currentHeight * 0.04,
            child: prizeLogo(context, Constants.prize1ImgRef, 0.25)),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          ranking.toString(),
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.08),
        ),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          guest!.name,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.08),
        ),
      )),
      TableCell(
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerRight,
          child: Text(
            (guest.completedAchievments * 10).toString(),
            style: CustomTextStyle.defaultBoldStyle
                .copyWith(fontSize: _currentWidth * 0.08),
          ),
        ),
      ),
    ]);
  }

  getSecondPrize(Guest? guest, int ranking) {
    return TableRow(children: [
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: SizedBox(
            width: _currentWidth * 0.065,
            height: _currentHeight * 0.038,
            child: prizeLogo(context, Constants.prize2ImgRef, 0.2)),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          ranking.toString(),
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.07),
        ),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          guest!.name,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.07),
        ),
      )),
      TableCell(
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerRight,
          child: Text(
            (guest.completedAchievments * 10).toString(),
            style: CustomTextStyle.defaultBoldStyle
                .copyWith(fontSize: _currentWidth * 0.07),
          ),
        ),
      ),
    ]);
  }

  getThirdPrize(Guest? guest, int ranking) {
    return TableRow(children: [
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: SizedBox(
            width: _currentWidth * 0.06,
            height: _currentHeight * 0.035,
            child: prizeLogo(context, Constants.prize3ImgRef)),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          ranking.toString(),
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.06),
        ),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          guest!.name,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: CustomTextStyle.defaultBoldStyle
              .copyWith(fontSize: _currentWidth * 0.06),
        ),
      )),
      TableCell(
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerRight,
          child: Text(
            (guest.completedAchievments * 10).toString(),
            style: CustomTextStyle.defaultBoldStyle
                .copyWith(fontSize: _currentWidth * 0.06),
          ),
        ),
      ),
    ]);
  }

  getDefault(Guest? guest, int ranking) {
    return TableRow(children: [
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.centerLeft,
        child: SizedBox(
            width: _currentWidth * 0.08, child: const Text(Constants.empty)),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.centerLeft,
        child: Text(
          ranking.toString(),
          style: CustomTextStyle.defaultStyle
              .copyWith(fontSize: _currentWidth * 0.055),
        ),
      )),
      TableCell(
          child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.centerLeft,
        child: Text(
          guest!.name,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: CustomTextStyle.defaultStyle
              .copyWith(fontSize: _currentWidth * 0.055),
        ),
      )),
      TableCell(
        child: Container(
          padding: const EdgeInsets.only(bottom: 15),
          alignment: Alignment.centerRight,
          child: Text(
            (guest.completedAchievments * 10).toString(),
            style: CustomTextStyle.defaultStyle
                .copyWith(fontSize: _currentWidth * 0.055),
          ),
        ),
      ),
    ]);
  }
}
