import 'package:bmap/di/di.dart';
import 'package:bmap/pages/navigation_page.dart';
import 'package:bmap/pages/parking_like.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bmap/components/atoms/parking_header.dart';
import 'package:bmap/pages/parking_detail.dart';

class AppSetting {
  static const double defaultPadding = 24;
}

class AppPalette {
  static const Color primary = Color(0xffBF4AD2);
  static const Color primaryVariant = Color(0xFFF7BA34);
  static const Color black = Color(0xFF000000);
  static Color disable = Colors.black12;
  static const Color background = Colors.white;

  static Color enableOrDisableColor(bool value) {
    return value ? primary : disable;
  }
}

List<Future> systemChromeTask = [
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [
  //   SystemUiOverlay.bottom,
  // ])
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ))
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // Status bar 투명하게 처리
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Future.wait(systemChromeTask);

  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '서울시 IOT 해커톤',
      // theme: ThemeData(
      //   primaryColor: Colors.white,
      //   primarySwatch: Colors.lightBlue,
      // ),
      initialRoute: "/navigation",
      routes: {
        "/": (context) => const PageParkingDetail(),
        "/like": (context) => const PageParkingLike(),
        "/parking_detail": (context) => const PageParkingDetail(),
        "/navigation": (context) => const NavigationPage()
      },
    );
  }
}
