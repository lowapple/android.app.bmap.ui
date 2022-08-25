import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParkingHeader extends StatelessWidget {
  final String headerTitle;

  const ParkingHeader({Key? key, required this.headerTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final statusHeight = MediaQuery.of(context).viewPadding.top;
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        final opacityReverse = 1.0 - opacity;

        return Stack(
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Opacity(
                opacity: opacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        color: Colors.blue,
                        width: double.infinity,
                        child: Image.network(
                          'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 18),
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headerTitle,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("#지하주차장"),
                                Text("#엘리베이터"),
                                Text("#경사로"),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                Text("서울 중구 세종대로 93(태평로2가)")
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: opacityReverse,
              child: Container(
                height: statusHeight + kToolbarHeight,
                color: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  height: kToolbarHeight,
                  padding: EdgeInsets.only(top: statusHeight),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      headerTitle,
                      style: const TextStyle(fontSize: 21),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: statusHeight + kToolbarHeight,
              color: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                height: kToolbarHeight,
                padding: EdgeInsets.only(top: statusHeight),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {},
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
