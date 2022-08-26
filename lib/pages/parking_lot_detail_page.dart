import 'package:coordinator_layout/coordinator_layout.dart';
import 'package:flutter/material.dart';

class ParkingLotDetailPage extends StatefulWidget {
  const ParkingLotDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParkingLotDetailPageState();
}

class _ParkingLotDetailPageState extends State<ParkingLotDetailPage> {
  @override
  Widget build(BuildContext context) {
    return CoordinatorLayout(
      headerMaxHeight: 200,
      headerMinHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
      headers: [
        Builder(builder: (context) {
          return SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverCollapsingHeader(
                builder: (context, offset, diff) {
                  return Text("ASDSASD");
                },
              ),
            ),
          );
        }),
      ],
      body: Container(height: null, child: Text("ASD")),
    );
  }
}
