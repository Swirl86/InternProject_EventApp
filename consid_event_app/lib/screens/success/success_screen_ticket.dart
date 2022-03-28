import 'package:consid_event_app/constants/constants.dart';
import 'package:consid_event_app/reusables/reusables.dart';
import 'package:consid_event_app/screens/checked_in/tickets_list.dart';
import 'package:consid_event_app/widget/top_confetti_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessScreenTicket extends StatelessWidget {
  const SuccessScreenTicket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentWidth = MediaQuery.of(context).size.width;
    final _currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: _currentHeight * 0.02),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const TicketsList()));
            },
            child: closeIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: TopConfettiWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sizedBoxTop(_currentHeight),
            SizedBox(
              height: _currentHeight * 0.2,
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
