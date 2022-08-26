import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class ParkingHeader extends StatelessWidget {
  final String parkingTitle;
  final List<String> parkingTags;
  final String parkingAddress;

  const ParkingHeader(
      {Key? key,
      required this.parkingTitle,
      required this.parkingTags,
      required this.parkingAddress})
      : super(key: key);

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
        final c =
            (255 - (255 * Interval(fadeStart, fadeEnd).transform(t))).toInt();
        final cc = Color.fromARGB(255, c, c, c);
        // final cc = Colors.white;
        return Stack(
          children: [
            Container(
              color: Colors.white,
              height: 280,
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
                        child: Image.asset(
                          'assets/parking_image.png',
                          fit: BoxFit.cover,
                        ),
                        // child: Image.network(
                        //   'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 18),
                      child: Container(
                        color: Colors.white,
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parkingTitle,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Wrap(
                              children:
                                  List.generate(parkingTags.length, (index) {
                                var isLast = index == parkingTags.length - 1;
                                if (isLast) {
                                  return Text(
                                    "#${parkingTags[index]} ",
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xff6B7684)),
                                  );
                                }
                                return Text(
                                  "#${parkingTags[index]} |",
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff6B7684)),
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                                Text(
                                  parkingAddress,
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xff6B7684)),
                                )
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
              child: SizedBox(
                height: statusHeight + kToolbarHeight,
                child: Container(
                  alignment: Alignment.center,
                  height: kToolbarHeight,
                  padding: EdgeInsets.only(top: statusHeight),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      parkingTitle,
                      style: const TextStyle(fontSize: 18),
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
                    icon: Icon(Icons.arrow_back_ios, color: cc),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
                    },
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
