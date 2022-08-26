import 'package:bmap/data/database/data_storage_local.dart';
import 'package:bmap/di/di.dart';
import 'package:bmap/models/like_model.dart';
import 'package:bmap/pages/parking_like.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageParkingLikeEditor extends StatefulWidget {
  final LikeModel? likeModel;

  const PageParkingLikeEditor({Key? key, this.likeModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageParkingLikeEditorState();

  static Future<bool> navigate(
      BuildContext context, LikeModel? likeModel) async {
    return await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageParkingLikeEditor(
              likeModel: likeModel,
            )));
  }
}

class _PageParkingLikeEditorState extends State<PageParkingLikeEditor> {
  TextEditingController? _controller;
  final _dataStorageLocal = getIt<DataStorageLocal>();
  final _likeModel = LikeModel();

  @override
  void initState() {
    _likeModel.id = widget.likeModel?.id;
    _likeModel.type = widget.likeModel?.type;
    _likeModel.likeName = widget.likeModel?.likeName;
    _likeModel.likeAddress = widget.likeModel?.likeAddress;
    _controller = TextEditingController(text: widget.likeModel?.likeName ?? "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "자주 가는 주차장",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop({
                  'type': _likeModel.type,
                  'likeName': _likeModel.likeName,
                  'likeAddress': _likeModel.likeAddress
                });
              },
            ),
          ),
          body: Column(children: [
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: _icon(),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: TextField(
                          controller: _controller,
                          onChanged: (text) {
                            setState(() {
                              _likeModel.likeName = text;
                            });
                          },
                          decoration: const InputDecoration(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 21,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: const Color(0xffF3F3F3),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          _likeModel.likeAddress ?? "",
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xff6B7684)),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              String address =
                                  await ParkingLikeMethod.searchAddress(
                                      _likeModel.likeAddress ?? "");
                              setState(() {
                                _likeModel.likeAddress = address;
                              });
                            },
                            icon: const Icon(Icons.map_outlined))
                      ],
                    )),
              ),
            )
          ]),
          bottomSheet: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: MaterialButton(
                    onPressed: () async {
                      // 키보드 내리기
                      FocusManager.instance.primaryFocus?.unfocus();
                      // 대기
                      await Future.delayed(const Duration(milliseconds: 200));
                      // 데이터 제거
                      await _dataStorageLocal.deleteLikeItem(_likeModel);
                      // 데이터 전달
                      Navigator.of(context).pop();
                    },
                    height: 48,
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xffBCBCBE)),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "삭제",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: MaterialButton(
                    onPressed: () async {
                      // 데이터 저장
                      FocusManager.instance.primaryFocus?.unfocus();
                      await Future.delayed(const Duration(milliseconds: 200));
                      await _dataStorageLocal.insertLikeItem(_likeModel);
                      //
                      Fluttertoast.showToast(msg: "즐겨찾기에 추가되었습니다");
                      Navigator.of(context).pop();
                    },
                    height: 48,
                    color: const Color(0xffFFE146),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xffFFE146)),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "저장",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pop();
          return true;
        });
  }

  Widget _icon() {
    IconData icon;
    if (widget.likeModel?.type == "home") {
      icon = Icons.home;
    } else if (widget.likeModel?.type == "work") {
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
