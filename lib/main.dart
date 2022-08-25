import 'dart:developer';
import 'dart:math';

import 'package:coordinator_layout/coordinator_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seoul_iot/components/atoms/parking_header.dart';
import 'package:seoul_iot/pages/parking_lot_detail_page.dart';
import 'dart:math' as math;

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
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // ErrorWidget.builder = (FlutterErrorDetails details) => Container();
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
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: ""),
        "/parking": (context) => const ParkingLotDetailPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;
  Color _textColor = Colors.red;

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _textColor = _isSliverAppBarExpanded ? Colors.red : Colors.blue;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final _items = [_parkingIoTStatBox(), _parkingIoTDataBox()];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 300,
            flexibleSpace: ParkingHeader(
              headerTitle: '한영 빌딩 주차장',
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: SizedBox()),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _items[index];

                // return Container(
                //   color: index.isOdd ? Colors.white : Colors.black12,
                //   height: 100.0,
                //   child: Center(
                //     child: Text('$index', textScaleFactor: 5),
                //   ),
                // );
              },
              childCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _parkingIoTStatBox() {
    return Container(
      width: double.infinity,
      color: const Color(0xffe7e7e8),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.all(21),
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      Icons.dangerous,
                      color: Colors.red,
                      size: 80,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      "자리가 없어요",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "장애인전용 ",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            children: [
                          TextSpan(
                              text: "3",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                          TextSpan(
                              text: "/3",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black))
                        ])),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "전체주차면 150",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              child: Text(
                "현재 시간 기준 (2022.08.27 오후 13:36)",
                style: TextStyle(color: Colors.grey),
              ),
              alignment: Alignment.centerRight,
            )
          ],
        ),
      ),
    );
  }

  Widget _parkingIoTDataBox() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "주차 IoT 데이터",
                  style: TextStyle(fontSize: 21),
                ),
                Spacer(),
                Text("2022.08.27 업데이트"),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(LineChartData(
                  titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                          drawBehindEverything: true)),
                  maxY: 30,
                  lineBarsData: [
                    LineChartBarData(
                        spots: const [
                          FlSpot(0, 0),
                          FlSpot(2, 0),
                          FlSpot(4, 0),
                          FlSpot(6, 0),
                          FlSpot(8, 20),
                          FlSpot(10, 30),
                          FlSpot(12, 20),
                          FlSpot(14, 10),
                          FlSpot(16, 10),
                          FlSpot(18, 0),
                          FlSpot(20, 0),
                          FlSpot(22, 0),
                        ],
                        isCurved: false,
                        color: Colors.orange,
                        barWidth: 1,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff12c2e9).withOpacity(0.4),
                              const Color(0xffc471ed).withOpacity(0.4),
                              const Color(0xfff64f59).withOpacity(0.4),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff12c2e9),
                            Color(0xffc471ed),
                            Color(0xfff64f59),
                          ],
                          stops: [0.1, 0.4, 0.9],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        dotData: FlDotData(show: false)),
                    LineChartBarData(
                        spots: const [
                          FlSpot(0, 0),
                          FlSpot(2, 0),
                          FlSpot(4, 0),
                          FlSpot(6, 0),
                          FlSpot(8, 10),
                          FlSpot(10, 20),
                          FlSpot(12, 20),
                          FlSpot(14, 30),
                          FlSpot(16, 20),
                          FlSpot(18, 10),
                          FlSpot(20, 0),
                          FlSpot(22, 0),
                        ],
                        isCurved: false,
                        color: Colors.black,
                        barWidth: 1,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                    radius: 3, color: Colors.white)))
                  ])),
            ),
            SizedBox(height: 16,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "월요일",
                      style: TextStyle(fontSize: 18),
                    ),
                    height: 53,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
