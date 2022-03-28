import 'package:consid_event_app/services/fire_auth.dart';
import 'package:consid_event_app/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// Local Imports
import 'services/remote_config_service.dart';
import 'theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FireAuth().signIn();
  await RemoteConfigService.instance.initialise();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const Home());
  });
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consid Event App',
      theme: CustomTheme.lightTheme,
      home: const Wrapper(),
    );
  }
}
