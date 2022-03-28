import 'package:admin_app/theme/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final String widgetType;

  const UserWidget({Key? key, required this.snapshot, required this.widgetType})
      : super(key: key);
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Column(children: [
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot data = widget.snapshot.data!.docs[index];

          if (widget.widgetType == "Everyone") {
            return ListTile(
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: _screenSize.width * 0.05, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(data['name']),
              leading: Visibility(
                visible: data['checked_in'] == true ? true : false,
                child: const Icon(
                  Icons.check_circle,
                  color: CustomColors.goldText,
                ),
              ),
            );
          } else {
            // What's returned if the list type is Scanned or Not Scanned
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: _screenSize.width * 0.06, vertical: 0.0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(data['name']),
            );
          }
        },
      ),
    ]);
  }
}
