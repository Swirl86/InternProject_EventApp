import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/services/image_url_cache.dart';
import 'package:consid_event_app/services/svg_picture_cache.dart';
import 'package:flutter/material.dart';

bottomLogo() {
  return Expanded(
      child: Container(
    alignment: Alignment.bottomRight,
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.logoImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context, Constants.logoImgRef, url, 'Consid Logo', 0.2, 0.5);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, 0.5);
        }
      },
    ),
  ));
}

achievementsLogo([double l = 0.3, double d = 0.6]) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.achievementsImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(context,
              Constants.achievementsImgRef, url, 'Achivement Logo', d, l);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, l);
        }
      },
    ),
  );
}

inactiveAchievementsLogo([double l = 0.1, double d = 0.4]) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder<String>(
      future:
          ImageUrlCache.instance.getSvgUrl(Constants.achievementInactiveImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context,
              Constants.achievementInactiveImgRef,
              url,
              'Achivement Inactive Logo',
              d,
              l);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, l);
        }
      },
    ),
  );
}

secretAchievementLogo(BuildContext context) {
  return SizedBox(
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.secretAchievImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context,
              Constants.secretAchievImgRef,
              url,
              'Secret Achievement Logo',
              0.35,
              0.35);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, 0.3);
        }
      },
    ),
  );
}

secretAchievementRibbonLogo([double d = 0.6]) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.secretAchievImgRef2),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context,
              Constants.secretAchievImgRef2,
              url,
              'Secret Achivement Ribbon Logo',
              d,
              d);
        } else {
          return Center(
              child: loadingSpinner(MediaQuery.of(context).size.width, d));
        }
      },
    ),
  );
}

ribbonLogo() {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.ribbonImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(context,
              Constants.ribbonImgRef, url, 'Achivement Ribbon Logo', 0.6, 0.4);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, 0.4);
        }
      },
    ),
  );
}

ticketLogo([double d = 0.45]) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.ticketsImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context, Constants.ticketsImgRef, url, 'Ticket Logo', d, 0.85);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, 0.85);
        }
      },
    ),
  );
}

prizeLogo(BuildContext context, String type, [double d = 0.1]) {
  return SizedBox(
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(type),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance
              .getSvgPicture(context, type, url, 'Prize Logo', d, d);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width, d);
        }
      },
    ),
  );
}
