import 'package:bmap/models/like_model.dart';
import 'package:bmap/pages/parking_like_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikeItem extends StatefulWidget {
  final LikeModel likeModel;
  final VoidCallback onFinished;

  const LikeItem({Key? key, required this.likeModel, required this.onFinished})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LikeItemState();
}

class _LikeItemState extends State<LikeItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          await PageParkingLikeEditor.navigate(context, widget.likeModel);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          // ignore
        }
        widget.onFinished();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _icon(),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.likeModel.likeName ?? "",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.likeModel.likeAddress ?? "",
                  style:
                      const TextStyle(fontSize: 17, color: Color(0xFF6B7684)),
                )
              ],
            )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.keyboard_arrow_right_sharp,
                color: Colors.black,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    IconData icon;
    if (widget.likeModel.type == "home") {
      icon = Icons.home;
    } else if (widget.likeModel.type == "work") {
      icon = Icons.business;
    } else {
      icon = Icons.star;
    }

    return Icon(
      icon,
      color: Colors.black,
      size: 18,
    );
  }
}
