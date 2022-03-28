import 'dart:developer';

import 'package:admin_app/models/event_info.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/services/new_event.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({
    Key? key,
  }) : super(key: key);
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  // References
  Firebase db = Firebase();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String titleInput = "";
  String descInput = "";
  String dropdownAchievementType = LocalVar.scanQr;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController = ScrollController(initialScrollOffset: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: _screenSize.height * 0.03),
                defaultTextTitle(_screenSize, LocalVar.createEvent,
                    _screenSize.width * 0.075),
                SizedBox(height: _screenSize.height * 0.01),
                defaultDivider(),
                Text(
                  LocalVar.eventStart,
                  style: CustomTextStyle.defaultStyle,
                  textAlign: TextAlign.center,
                ),
                defaultDivider(0.5),
                SizedBox(
                  height: _screenSize.height * 0.15,
                  child: CupertinoDatePicker(
                      use24hFormat: true,
                      initialDateTime: startDate,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (dateTime) => setState(() {
                            startDate = dateTime;
                          })),
                ),
                defaultDivider(0.5),
                Text(
                  LocalVar.eventEnd,
                  style: CustomTextStyle.defaultStyle,
                  textAlign: TextAlign.center,
                ),
                defaultDivider(0.5),
                SizedBox(
                  height: _screenSize.height * 0.15,
                  child: CupertinoDatePicker(
                      use24hFormat: true,
                      initialDateTime: endDate,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (dateTime) => setState(() {
                            endDate = dateTime;
                          })),
                ),
                defaultDivider(),
                SizedBox(height: _screenSize.height * 0.03),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                              hintText: LocalVar.hintTitle,
                              hintStyle: CustomTextStyle.hintStyle,
                              errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _screenSize.width * 0.05)),
                          textAlign: TextAlign.left,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return LocalVar.invalidTitle;
                            }
                            return null;
                          },
                          style: CustomTextStyle.codeInputStyle,
                          onChanged: (value) {
                            setState(() {
                              titleInput = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: _screenSize.height * 0.02),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 4,
                          keyboardType: TextInputType.multiline,
                          maxLines: 30,
                          controller: _descCtrl,
                          decoration: InputDecoration(
                              hintText: LocalVar.desc,
                              hintStyle: CustomTextStyle.hintStyle,
                              errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _screenSize.width * 0.05)),
                          textAlign: TextAlign.left,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 15) {
                              return LocalVar.invalidDesc;
                            }
                            return null;
                          },
                          style: CustomTextStyle.codeInputStyle,
                          onChanged: (value) {
                            setState(() {
                              descInput = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _screenSize.height * 0.02,
                ),
                defaultTextButton(context, LocalVar.send.toUpperCase(),
                    () async {
                  if (_formKey.currentState!.validate()) {
                    eventConfirmDialog(context);
                  }
                },
                    textSize: _screenSize.width * 0.053,
                    useConstraint: true,
                    constraintMaxHeight: _screenSize.height * 0.053,
                    constraintMaxWidth: _screenSize.width * 0.36),
                SizedBox(height: _screenSize.height * 0.03),
              ],
            ),
          ),
        ));
  }

  eventConfirmDialog(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          shape:
              const RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
          title:
              Text(LocalVar.confirmEvent, style: CustomTextStyle.defaultStyle),
          content: Wrap(children: [
            Text(LocalVar.event1),
            Text(LocalVar.event2),
            Text(LocalVar.event3),
          ]),
          actions: [
            TextButton(
              child: Text(LocalVar.cancel),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(LocalVar.confirm),
              onPressed: () async {
                EventInfo thisEvent = EventInfo(
                    title: titleInput,
                    description: descInput,
                    endDate: endDate,
                    startDate: startDate);

                NewEvent newEvent = NewEvent();

                Navigator.of(context, rootNavigator: true).pop();

                await newEvent.backupFormerEvent();
                await newEvent.eraseFormerData();
                await newEvent.setEventInfo(thisEvent);
              },
            )
          ],
        );
      },
    );
  }
}
