import 'dart:convert';
import 'dart:math';

import 'package:bmap/components/atoms/like_item.dart';
import 'package:bmap/data/database/data_storage_local.dart';
import 'package:bmap/di/di.dart';
import 'package:bmap/models/like_model.dart';
import 'package:bmap/pages/parking_like_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParkingLikeMethod {
  static const _platform = MethodChannel('/like');

  static Future<String> searchAddress(String address) async {
    final resRaw =
        await _platform.invokeMethod('searchAddress', {'address': address});
    final res = Map<String, dynamic>.from(resRaw);
    if (kDebugMode) {
      print('address: $res');
    }

    return res["address"];
  }

  static Future<void> saveAddress(List<LikeModel> likes) async {
    List<String> data = likes.map((e) => jsonEncode(e.toJson())).toList();
    final resRaw = await _platform.invokeMethod('saveAddress', data);
    if (kDebugMode) {
      print('saveAddress: $resRaw');
    }
  }
}

class PageParkingLike extends StatefulWidget {
  const PageParkingLike({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageParkingLikeState();
}

class _PageParkingLikeState extends State<PageParkingLike> {
  final _dataStorageLocal = getIt<DataStorageLocal>();

  List<LikeModel>? likeModels;

  List<Widget> get items {
    List<LikeModel> items = [];
    items.addAll(likeModels ?? []);
    List<Widget> itemWidgets = List.generate(items.length, (index) {
      return LikeItem(
        likeModel: items[index],
        onFinished: () {
          () async {
            _doUpdateItems();
          }();
        },
      );
    });
    itemWidgets.add(_addLike());
    return itemWidgets;
  }

  _doUpdateItems() async {
    // 데이터가 없을 때 데이터를 넣어준다.
    likeModels = await _dataStorageLocal.likeItems();
    if (likeModels!.isEmpty) {
      await _dataStorageLocal.insertLikeItem(
          LikeModel(id: 0, type: "home", likeName: "집", likeAddress: ""));
      await _dataStorageLocal.insertLikeItem(
          LikeModel(id: 1, type: "work", likeName: "회사", likeAddress: ""));
    }
    likeModels = await _dataStorageLocal.likeItems();
    // 데이터 전달
    await ParkingLikeMethod.saveAddress(likeModels!);
    if (kDebugMode) {
      print("items size: ${likeModels!.length}");
      print("items: ${likeModels!.length}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _doUpdateItems();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "자주 가는 주차장",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => false);
                SystemNavigator.pop();
              },
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              SingleChildScrollView(
                child: Column(
                  children: items,
                ),
              )
            ],
          ),
        ),
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        });
  }

  Widget _addLike() {
    return InkWell(
      onTap: () async {
        await PageParkingLikeEditor.navigate(
            context, LikeModel(id: likeModels?.length ?? -1));
        await _doUpdateItems();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.add_circle_outline,
                size: 18,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "추가하기",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
