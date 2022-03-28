import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/constants/local.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/widget/reusables/tickets.dart';
import 'package:consid_event_app/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';

class TicketWidget extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  final String guestCode;
  const TicketWidget(
      {Key? key, required this.snapshot, required this.guestCode})
      : super(key: key);
  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      sizedBoxTop(_currentHeight),
      sizedBoxTop(_currentHeight),
      Center(
        child: Text(
          Local.ticketsListTitle,
          style: CustomTextStyle.titleText
              .copyWith(fontSize: _currentWidth * 0.15),
        ),
      ),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 5),
        shrinkWrap: true,
        itemCount: widget.snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot data = widget.snapshot.data!.docs[index];
          return ListTile(
            title: getUserTicket(
                data[Constants.typeRef].toString().toUpperCase(),
                data[Constants.usedRef],
                context,
                "${widget.guestCode}/${data.id}"),
          );
        },
      ),
      sizedBoxTop(_currentHeight),
    ]));
  }
}
