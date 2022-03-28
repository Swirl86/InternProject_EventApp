import 'package:admin_app/models/event_info.dart';
import 'package:admin_app/services/firebase.dart';
import 'package:admin_app/services/new_event.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/theme/custom_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/constants.dart';

Firebase db = Firebase();

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

EventInfo thisEventInfo = EventInfo(
    description: "",
    title: "",
    startDate: DateTime.now(),
    endDate: DateTime.now());

String formTitle = "";
String formDescription = "";
DateTime formStartDate = DateTime.now();
DateTime formEndDate = DateTime.now();

class EventDataEdit extends StatefulWidget {
  const EventDataEdit({
    Key? key,
  }) : super(key: key);
  @override
  _EventDataEditState createState() => _EventDataEditState();
}

class _EventDataEditState extends State<EventDataEdit> {
  final _formKey = GlobalKey<FormState>();
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: _screenSize.width * 0.09,
          ),
        ),
        body: Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Container(
                margin: defaultPageMargins(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: _screenSize.height * 0.03),
                    defaultTextTitle(_screenSize, LocalVar.editEventData,
                        _screenSize.width * 0.075),
                    SizedBox(height: _screenSize.height * 0.01),
                    defaultDivider(),
                    FutureBuilder<DocumentSnapshot>(
                      future: db.getEventData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return showAlertDialog(context,
                              Constants.somethingWentWrong, Colors.red);
                        } else if (snapshot.hasData) {
                          thisEventInfo = EventInfo(
                              description: snapshot.data?.get('description'),
                              title: snapshot.data?.get('title'),
                              startDate:
                                  snapshot.data?.get('start_date').toDate(),
                              endDate: snapshot.data?.get('end_date').toDate());

                          return _showEventDataForm(_screenSize);
                        } else {
                          return loadingSpinner();
                        }
                      },
                    )
                  ],
                ),
              ),
            )));
  }

  _showEventDataForm(Size _screenSize) {
    return Column(children: [
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
            initialDateTime: thisEventInfo.startDate,
            mode: CupertinoDatePickerMode.dateAndTime,
            onDateTimeChanged: (dateTime) => setState(() {
                  formStartDate = dateTime;
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
            initialDateTime: thisEventInfo.endDate,
            mode: CupertinoDatePickerMode.dateAndTime,
            onDateTimeChanged: (dateTime) => setState(() {
                  formEndDate = dateTime;
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
                initialValue: thisEventInfo.title,
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
                onChanged: (title) {
                  setState(() {
                    formTitle = title;
                  });
                },
              ),
            ),
            SizedBox(height: _screenSize.height * 0.02),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: TextFormField(
                minLines: 4,
                keyboardType: TextInputType.multiline,
                maxLines: 30,
                initialValue: thisEventInfo.description,
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
                onChanged: (description) {
                  setState(() {
                    formDescription = description;
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
      defaultTextButton(context, LocalVar.save.toUpperCase(), () async {
        if (_formKey.currentState!.validate()) {
          EventInfo sendEventInfo = EventInfo(
            description: formDescription,
            title: formTitle,
            startDate: formStartDate,
            endDate: formEndDate,
          );

          _eventConfirmDialog(context, sendEventInfo);
        }
      },
          textSize: _screenSize.width * 0.053,
          useConstraint: true,
          constraintMaxHeight: _screenSize.height * 0.053,
          constraintMaxWidth: _screenSize.width * 0.36),
      SizedBox(height: _screenSize.height * 0.03),
    ]);
  }
}

_eventConfirmDialog(BuildContext context, EventInfo eventInfo) {
  final _screenSize = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.orange)),
        title: Text(LocalVar.confirmEditEvent,
            style: CustomTextStyle.defaultStyle),
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
              NewEvent editCurrentEvent = NewEvent();
              editCurrentEvent.setEventInfo(eventInfo);
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    },
  );
}
