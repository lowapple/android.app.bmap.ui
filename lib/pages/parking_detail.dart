import 'package:bmap/components/atoms/parking_header.dart';
import 'package:coordinator_layout/coordinator_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PageParkingDetail extends StatefulWidget {
  const PageParkingDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageParkingDetailState();
}

class _PageParkingDetailState extends State<PageParkingDetail> {
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
    final _items = [
      _parkingIoTStatBox(),
      SizedBox(
        height: 4,
      ),
      _parkingIoTDataBox(),
      SizedBox(
        height: 4,
      ),
      _parkingConvenience(),
      SizedBox(
        height: 4,
      ),
      _parkingBottomBox()
    ];

    return Scaffold(
      backgroundColor: Color(0xffe7e7e7),
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
      color: Colors.white,
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
            SizedBox(
              height: 16,
            ),
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
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              color: Color(0xffe7e7e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.all(21),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("지난 주 월요일은 오후 14시에 가장 인기가 많았어요."),
                      Text("매주 평일 오전 10시에 이용이 많아요")
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
      padding: EdgeInsets.only(top: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "편의 정보",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ListTile(
              title: Text("엘리베이터"),
              subtitle: Text("주차장과 연결된 엘리베이터가 있어 이동이 편리합니다"),
              trailing: Image.asset(
                "assets/ic_elevator.png",
                width: 50,
                height: 50,
              )),
          SizedBox(
            height: 16,
          ),
          ListTile(
              title: Text("경사로"),
              subtitle: Text("건물 입구에 경사로가 설치되어 있어 휠체어로 이동하기 수월합니다"),
              trailing: Image.asset(
                "assets/ic_stair.png",
                width: 50,
                height: 50,
              )),
          SizedBox(
            height: 16,
          ),
          ListTile(
              title: Text("장애인전용 화장실"),
              subtitle: Text("휠체어사용자가 이용하기 편리한 장애인 전용 화장실이 구비되어 있습니다"),
              trailing: Image.asset(
                "assets/ic_toilet.png",
                width: 50,
                height: 50,
              ))
        ],
      ),
    );
  }

  Widget _parkingBottomBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: roundedIconButton((Icons.star_border), "즐겨찾기"),
          ),
          Expanded(
            child: roundedIconButton((Icons.edit), "즐겨찾기"),
          ),
          Expanded(
            child: roundedIconButton((Icons.ios_share), "즐겨찾기"),
          )
        ],
      ),
    );
  }

  Widget roundedIconButton(IconData icon, String text) {
    return Column(
      children: [
        ButtonTheme(
          minWidth: 50,
          height: 80,
          child: MaterialButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(25)),
            onPressed: () {},
            child: Icon(
              icon,
              size: 45,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(text)
      ],
    );
  }
}
