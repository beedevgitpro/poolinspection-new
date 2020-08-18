import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';
import 'config/app_config.dart' as config;
import 'route_generator.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GlobalConfiguration().loadFromAsset("configurations");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            title: 'Pool Inspection',
            initialRoute: '/Splash',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.white,
              accentColor: config.Colors().secondColor(1),
              focusColor: config.Colors().accentColor(1),
              hintColor: config.Colors().mainColor(1),
              textTheme: TextTheme(
               
                headline4: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondColor(1)),
                headline6: TextStyle(
                    
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainColor(1)),
                
              ),
            ),
          );
        
  }
}
