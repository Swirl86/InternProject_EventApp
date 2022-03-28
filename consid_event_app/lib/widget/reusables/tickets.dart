import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/ticket/chosen_ticket.dart';
import 'package:consid_event_app/services/image_url_cache.dart';
import 'package:consid_event_app/services/svg_picture_cache.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

getUserTicket(String type, bool used, BuildContext context, String qrCode) {
  if (used) {
    return getUsedTicketWidget(type, context);
  } else {
    return getUnUsedTicketWidget(type, context, qrCode);
  }
}

getUsedTicketWidget(String type, BuildContext context) {
  final _currentWidth = MediaQuery.of(context).size.width;
  final _currentHeight = MediaQuery.of(context).size.height;

  return Container(
      margin: EdgeInsets.only(top: _currentHeight * 0.05),
      child: Stack(
        children: [
          usedTicketLogo(),
          Table(
              columnWidths: const {
                0: FractionColumnWidth(.7),
                1: FractionColumnWidth(.3),
                2: FractionColumnWidth(.1)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  TableCell(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: _currentWidth * 0.12,
                            right: _currentWidth * 0.06),
                        child: Stack(
                          children: [
                            Container(
                                alignment: Alignment.topCenter,
                                margin:
                                    EdgeInsets.only(top: _currentWidth * 0.02),
                                child: Text(Local.ticketCheers, // CHEERS
                                    style: CustomTextStyle.ticketUsedTextStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.095))),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.14),
                              child: const Text(Local.ticketThis, // THIS
                                  style: CustomTextStyle.ticketUsedTextStyle),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.19),
                              width: _currentWidth * 0.5,
                              height: _currentHeight * 0.05,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(type, // TICKET TYPE
                                      style: CustomTextStyle.ticketUsedTextStyle
                                          .copyWith(
                                              fontSize:
                                                  _currentWidth * 0.195))),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.24),
                              child: const Text(
                                  Local.ticketWasOnUs, // WAS ON US
                                  style: CustomTextStyle.ticketUsedTextStyle),
                            ),
                          ],
                        )),
                  ),
                ]),
              ]),
        ],
      ));
}

getUnUsedTicketWidget(String type, BuildContext context, String qrCode) {
  final _currentWidth = MediaQuery.of(context).size.width;
  final _currentHeight = MediaQuery.of(context).size.height;

  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChosenTicket(
                      qrCode: qrCode,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(top: _currentHeight * 0.05),
        child: Stack(
          children: [
            unUsedTicketLogo(),
            Table(
              columnWidths: const {
                0: FractionColumnWidth(.7),
                1: FractionColumnWidth(.3),
                2: FractionColumnWidth(.1)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  TableCell(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: _currentWidth * 0.12,
                            right: _currentWidth * 0.06),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                                margin:
                                    EdgeInsets.only(top: _currentWidth * 0.02),
                                child: Text(Local.ticketCheers, // CHEERS
                                    style: CustomTextStyle.ticketUnUsedTextStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.095))),
                            Container(
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.14),
                              child: const Text(Local.ticketThis, // THIS
                                  style: CustomTextStyle.ticketUnUsedTextStyle),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.19),
                              width: _currentWidth * 0.5,
                              height: _currentWidth * 0.1,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(type, // TICKET TYPE
                                      style: CustomTextStyle
                                          .ticketUnUsedTextStyle
                                          .copyWith(
                                              fontSize:
                                                  _currentWidth * 0.0195))),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: _currentWidth * 0.25),
                              child: const Text(Local.ticketIsOnUs, // IS ON US
                                  style: CustomTextStyle.ticketUnUsedTextStyle),
                            ),
                          ],
                        )),
                  ),
                  TableCell(
                    child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(
                            bottom: _currentHeight * 0.03,
                            right: _currentWidth * 0.05,
                            left: _currentWidth * 0.01),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    top: _currentHeight * 0.001),
                                child: Text(Local.ticketAmount,
                                    style: CustomTextStyle.ticketRightSideStyle
                                        .copyWith(
                                            fontSize: _currentWidth * 0.08))),
                            Container(
                              margin:
                                  EdgeInsets.only(top: _currentHeight * 0.05),
                              child: const Text(Local.ticketFree,
                                  style: CustomTextStyle.ticketRightSideStyle),
                            ),
                            Container(
                              width: _currentWidth * 0.15,
                              margin:
                                  EdgeInsets.only(top: _currentHeight * 0.08),
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(type,
                                      style: CustomTextStyle
                                          .ticketRightSideStyle)),
                            ),
                          ],
                        )),
                  ),
                  TableCell(
                    child: Container(),
                  )
                ]),
              ],
            ),
          ],
        ),
      ));
}

unUsedTicketLogo() {
  return Container(
    padding: const EdgeInsets.only(left: 10),
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.ticketUnusedImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(
              context,
              Constants.ticketUnusedImgRef,
              url,
              'Unused Ticket Logo',
              0.85,
              0.2);
        } else {
          return Center(
              child: loadingSpinner(MediaQuery.of(context).size.height, 0.06));
        }
      },
    ),
  );
}

usedTicketLogo() {
  return Container(
    padding: const EdgeInsets.only(left: 10),
    child: FutureBuilder<String>(
      future: ImageUrlCache.instance.getSvgUrl(Constants.ticketUsedImgRef),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return showAlertDialog(
              context, Constants.somethingWentWrong, Colors.red);
        } else if (snapshot.hasData) {
          String url = snapshot.data!;
          return SvgPictureCache.instance.getSvgPicture(context,
              Constants.ticketUsedImgRef, url, 'Used Ticket Logo', 0.6, 0.6);
        } else {
          return loadingSpinner(MediaQuery.of(context).size.width);
        }
      },
    ),
  );
}
