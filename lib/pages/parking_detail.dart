import 'dart:convert';
import 'dart:math';

import 'package:bmap/components/atoms/parking_header.dart';
import 'package:bmap/data/network/data_network.dart';
import 'package:bmap/di/di.dart';
import 'package:bmap/models/like_model.dart';
import 'package:bmap/models/park_detail.dart';
import 'package:bmap/models/park_facilities.dart';
import 'package:bmap/pages/navigation_page.dart';
import 'package:bmap/pages/parking_like_editor.dart';
import 'package:crypto/crypto.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PageParkingDetail extends StatefulWidget {
  const PageParkingDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageParkingDetailState();
}

class _PageParkingDetailState extends State<PageParkingDetail> {
  final platform = const MethodChannel('/parking');
  final network = getIt<DataNetwork>();

  late ScrollController _scrollController;
  var _currentDateString = "";
  var _ioTUpdateDateString = "";
  final weekends = ['월', '화', '수', '목', '금', '토', '일'];
  var selectedWeekend = '월';
  var selectedMaxHour = '14';
  var weeklyMaxHour = '14';

  // 주차장 데이터
  ParkDetail _parkDetail = ParkDetail();
  ParkFacilities _parkFacilities = ParkFacilities();
  var _currentFacilities = [];

  final parkFacilitiesDetails = {
    'elevator': {
      "icon": 'assets/ic_elevator.png',
      'name': '엘리베이터',
      'desc': '주차장과 연결된 엘리베이터가 있어 이동이 편리합니다.'
    },
    'wideExit': {
      "icon": 'assets/ic_door.png',
      'name': '넓은 출입구',
      'desc': '장애인등의 출입이 가능하도록 유효폭·형태 및 부착물 등을 고려한 출입구입니다.'
    },
    'ramp': {
      "icon": 'assets/ic_ramp.png',
      'name': '경사로',
      'desc': '건물 입구에 경사로가 설치되어 있어 휠체어로 이동하기 수월합니다.'
    },
    'accessRoads': {
      "icon": 'assets/ic_access_roads.png',
      'name': '접근로',
      'desc': '외부에서 건물 주출입구에 이르는 접근로는 유효폭·기울기와 바닥의 재질 및 마감등을 고려했습니다.'
    },
    'wheelchairLift': {
      "icon": 'assets/ic_wheelchair.png',
      'name': '휠체어 리프트',
      'desc': '1개 층에서 다른 층으로 편리하게 이동할 수 있도록 설치한 리프트입니다.'
    },
    'brailleBlock': {
      "icon": 'assets/ic_block.png',
      'name': '점자 블록',
      'desc': '공원과 도로 또는 교통시설을 연결하는 보도에 설치됩니다.'
    },
    'exGuidance': {
      "icon": 'assets/ic_dot.png',
      'name': '시각장애인 유도 안내',
      'desc': '공원의 주출입구부근에 설치된 점자안내판·촉지도식 안내판·음성안내장치 또는 기타 유도신호장치입니다.'
    },
    'exTicketOffice': {
      "icon": 'assets/ic_ticket.png',
      'name': '장애인 전용 매표소',
      'desc': '장애인등이 편리하게 이용할 수 있도록 형태·규격 및 부착물등을 고려한 매표소입니다.'
    },
    'exRestroom': {
      "icon": 'assets/ic_toilet.png',
      'name': '장애인전용 화장실',
      'desc': '휠체어사용자가 이용하기 편리한 장애인전용 화장실이 구비되어 있습니다.'
    }
  };

  var _dailyBarData = const [
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
  ];

  var _weeklyBar = const [
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
  ];

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  Future<void> _loadData() async {
    final resRaw = await platform.invokeMethod("loadData");
    final res = json.decode(resRaw);
    _parkDetail = ParkDetail.fromJson(res);
    setState(() {});
    _parkFacilities = await network.getParkFacilities(_parkDetail.parkCode!);

    // _parkFacilities = ParkFacilities.fromJson({});
    // _parkFacilities.elevator = true;
    // _parkFacilities.wideExit = true;
    // _parkFacilities.ramp = true;

    // 엘리베이터
    if (_parkFacilities.elevator!) {
      _currentFacilities.add(parkFacilitiesDetails['elevator']);
    }
    if (_parkFacilities.wideExit!) {
      _currentFacilities.add(parkFacilitiesDetails['wideExit']);
    }
    if (_parkFacilities.ramp!) {
      _currentFacilities.add(parkFacilitiesDetails['ramp']);
    }
    if (_parkFacilities.accessRoads!) {
      _currentFacilities.add(parkFacilitiesDetails['accessRoads']);
    }
    if (_parkFacilities.wheelchairLift!) {
      _currentFacilities.add(parkFacilitiesDetails['wheelchairLift']);
    }
    if (_parkFacilities.brailleBlock!) {
      _currentFacilities.add(parkFacilitiesDetails['brailleBlock']);
    }
    if (_parkFacilities.exGuidance!) {
      _currentFacilities.add(parkFacilitiesDetails['exGuidance']);
    }
    if (_parkFacilities.exTicketOffice!) {
      _currentFacilities.add(parkFacilitiesDetails['exTicketOffice']);
    }
    if (_parkFacilities.exRestroom!) {
      _currentFacilities.add(parkFacilitiesDetails['exRestroom']);
    }

    setState(() {});

    if (kDebugMode) {
      print(_parkDetail.toJson());
      print(_parkFacilities.toJson());
    }
  }

  @override
  void initState() {
    initializeDateFormatting('ko_KR', null);
    _currentDateString =
        DateFormat("yyyy.MM.dd a HH:mm").format(DateTime.now());
    _ioTUpdateDateString = DateFormat("yyyy.MM.dd.").format(DateTime.now());

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // _textColor = _isSliverAppBarExpanded ? Colors.red : Colors.blue;
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _loadData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _parkingIoTStatBox(),
      const SizedBox(
        height: 4,
      ),
      _parkingIoTDataBox(),
      const SizedBox(
        height: 4,
      ),
      _parkingConvenience(),
      const SizedBox(
        height: 4,
      ),
      _parkingBottomBox(),
      const SizedBox(
        height: 64,
      )
    ];

    return Scaffold(
      backgroundColor: const Color(0xffe7e7e7),
      bottomSheet: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Expanded(
              child: MaterialButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NavigationPage()));
            },
            height: 48,
            color: const Color(0xffFFE146),
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffFFE146)),
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "목적지 설정",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 270,
            flexibleSpace: ParkingHeader(
              parkingTitle: _parkDetail.parkName ?? '한영 빌딩 주차장',
              parkingTags:
                  _currentFacilities.map((e) => e['name'].toString()).toList(),
              parkingAddress: _parkDetail.newAddr ?? '서울 중구 세종대로 93(태평로2가)',
            ),
            bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0), child: SizedBox()),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return items[index];

                // return Container(
                //   color: index.isOdd ? Colors.white : Colors.black12,
                //   height: 100.0,
                //   child: Center(
                //     child: Text('$index', textScaleFactor: 5),
                //   ),
                // );
              },
              childCount: items.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _parkingIoTStatBox() {
    String statusString;
    String statusIcon;
    if (_parkDetail.parkState == "만차") {
      statusIcon = 'assets/parking_no.png';
      statusString = "자리가 없어요";
    } else if (_parkDetail.parkState == "혼잡") {
      statusIcon = 'assets/parking_war.png';
      statusString = "자리가 혼잡해요";
    } else {
      statusIcon = 'assets/parking_yes.png';
      statusString = "자리가 여유있어요";
    }

    return Container(
      width: double.infinity,
      color: const Color(0xffe7e7e8),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
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
                    SizedBox(
                      width: 53,
                      height: 53,
                      child: Image.asset(statusIcon),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      statusString,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "장애인전용 ",
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xff6B7684)),
                            children: [
                          TextSpan(
                              text: "${_parkDetail.nowParkCount ?? "1"}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "/${_parkDetail.maxParkCount ?? "3"}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))
                        ])),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "전체주차면 150",
                      style: TextStyle(fontSize: 14, color: Color(0xff949BA5)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "현재 시간 기준 ($_currentDateString)",
                style: const TextStyle(color: Color(0xff6B7684)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _parkingIoTDataBox() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "주차 IoT 데이터",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Spacer(),
                Text(
                  "$_ioTUpdateDateString 업데이트",
                  style:
                      const TextStyle(color: Color(0xff6B7684), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: const [
                Icon(
                  Icons.circle_outlined,
                  color: Color(0xff505967),
                  size: 9,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "일별 데이터",
                  style: TextStyle(fontSize: 12, color: Color(0xff505967)),
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.circle,
                  color: Color(0xffFFE146),
                  size: 9,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "주간 평균 데이터",
                  style: TextStyle(fontSize: 12, color: Color(0xff505967)),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            _charts(),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: weekends.map((e) {
                  Color color;
                  Color titleColor;
                  if (e == selectedWeekend) {
                    color = const Color(0xff3182F6);
                    titleColor = const Color(0xff3182F6);
                  } else {
                    color = const Color(0xffBCBCBE);
                    titleColor = const Color(0xffBCBCBE);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          selectedWeekend = e;
                          // 랜덤 데이터 생성
                          _dailyBarData = List.generate(12, (index) {
                            return FlSpot(
                                index * 2, Random().nextInt(30).toDouble());
                          });
                          // _weeklyBar = List.generate(12, (index) {
                          //   return FlSpot(
                          //       index * 2, Random().nextInt(30).toDouble());
                          // });
                        });
                      },
                      height: 53,
                      minWidth: 50,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: color),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        "$e요일",
                        style: TextStyle(fontSize: 18, color: titleColor),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              elevation: 0,
              color: const Color(0xffe7e7e7),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle_outlined,
                            color: Color(0xff505967),
                            size: 9,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "지난 주",
                                  style: const TextStyle(
                                      color: Color(0xff505967), fontSize: 13),
                                  children: [
                                TextSpan(
                                    text: "$selectedWeekend요일",
                                    style: const TextStyle(
                                        color: Color(0xff3182F6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                TextSpan(
                                    text:
                                        "은 오후 $selectedMaxHour시에 가장 인기가 많았어요.",
                                    style: const TextStyle(fontSize: 13))
                              ])),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color(0xffFFE146),
                            size: 9,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "매주 평일 ",
                                  style: const TextStyle(
                                      color: Color(0xff505967), fontSize: 13),
                                  children: [
                                TextSpan(
                                    text: "은 오후 $weeklyMaxHour시에 가장 이용이 많아요",
                                    style: const TextStyle(fontSize: 13))
                              ])),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _parkingConvenience() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "편의 정보",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: List.generate(_currentFacilities.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                    title: Text(
                      _currentFacilities[index]['name'],
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _currentFacilities[index]['desc'],
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff4E5968)),
                      ),
                    ),
                    trailing: Image.asset(
                      "${_currentFacilities[index]['icon']}",
                      width: 50,
                      height: 50,
                    )),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _parkingBottomBox() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 32),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: roundedIconButton((Icons.star_border), "즐겨찾기", () async {
              final id = _parkDetail.parkCode!.toString();
              var cid = utf8.encode(id).reduce((a, b) => a + b);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PageParkingLikeEditor(
                        likeModel: LikeModel(
                            id: cid,
                            type: 'like',
                            likeName: _parkDetail.parkName,
                            likeAddress: _parkDetail.newAddr),
                      )));
            }),
          ),
          Expanded(
            child: roundedIconButton((Icons.edit), "신고", () async {
              await platform.invokeMethod("launchReport");
            }),
          ),
          Expanded(
            child: roundedIconButton((Icons.ios_share), "공유", () async {}),
          )
        ],
      ),
    );
  }

  Widget _charts() {
    final weekly = LineChartBarData(
        spots: _weeklyBar,
        isCurved: false,
        color: const Color(0xffFFE146),
        barWidth: 1,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              const Color(0xffFFE146).withOpacity(0.4),
              const Color(0xffFFE146).withOpacity(0.4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFFE146),
            Color(0xffFFE146),
            Color(0xffFFE146),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        dotData: FlDotData(show: false));

    // 제일 최대값을 찾는다.
    final dailyBarValues = _dailyBarData.map((e) => e.y).toList();
    final dailyBarValuesMax = dailyBarValues.reduce(max);
    final dailyBarMaxIndex = dailyBarValues.indexOf(dailyBarValuesMax);
    setState(() {
      selectedMaxHour = _dailyBarData
          .map((e) => e.x)
          .toList()[dailyBarMaxIndex]
          .toInt()
          .toString();
    });
    // 매주 최대값
    final weeklyBarValues = _weeklyBar.map((e) => e.y).toList();
    final weeklyBarValuesMax = weeklyBarValues.reduce(max);
    final weeklyBarMaxIndex = weeklyBarValues.indexOf(weeklyBarValuesMax);
    setState(() {
      selectedMaxHour = _dailyBarData
          .map((e) => e.x)
          .toList()[dailyBarMaxIndex]
          .toInt()
          .toString();

      weeklyMaxHour = _weeklyBar
          .map((e) => e.x)
          .toList()[weeklyBarMaxIndex]
          .toInt()
          .toString();
    });

    final showIndicator = [dailyBarMaxIndex];

    final daily = LineChartBarData(
        showingIndicators: showIndicator,
        spots: _dailyBarData,
        isCurved: false,
        color: Colors.black,
        barWidth: 1,
        dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(radius: 3, color: Colors.white)));

    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(
          showingTooltipIndicators: showIndicator.map((index) {
            return ShowingTooltipIndicators(
                [LineBarSpot(daily, 1, daily.spots[index])]);
          }).toList(),
          lineTouchData: LineTouchData(
              enabled: false,
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                        color: const Color(0xffBCBCBE),
                        strokeWidth: 1,
                        dashArray: [3]),
                    FlDotData(
                      show: false,
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: const Color(0x26f32400),
                  tooltipPadding: const EdgeInsets.all(4),
                  tooltipBorder: const BorderSide(color: Color(0x26f32400)),
                  tooltipRoundedRadius: 10,
                  getTooltipItems: (List<LineBarSpot> lineBarSpot) {
                    return lineBarSpot.map((lineBarSpot) {
                      return LineTooltipItem(
                          "만차", const TextStyle(color: Color(0xffF32400)));
                    }).toList();
                  })),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(color: const Color(0xffD4D4D9), strokeWidth: 0.5);
              }),
          titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style =
                            TextStyle(fontSize: 13, color: Color(0xff46464E));
                        final number = NumberFormat("00");

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            number.format(value.toInt()),
                            style: style,
                          ),
                        );
                      }))),
          maxY: 30,
          lineBarsData: [weekly, daily])),
    );
  }

  Widget roundedIconButton(IconData icon, String text, VoidCallback callback) {
    return Column(
      children: [
        ButtonTheme(
          minWidth: 70,
          height: 70,
          child: MaterialButton(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            onPressed: callback,
            child: Icon(
              icon,
              size: 30,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(text)
      ],
    );
  }
}
