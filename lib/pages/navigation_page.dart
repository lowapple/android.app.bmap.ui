import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;
  bool animationFinished = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _offsetFloat =
        Tween(begin: const Offset(0.0, -0.9), end: const Offset(0.0, 0.5))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetFloat.addListener(() async {
      if (_controller.isCompleted) {
        if (animationFinished) return;
        await Future.delayed(const Duration(seconds: 1));
        animationFinished = true;
        _controller.reverse();
      }
      setState(() {});
    });

    () async {
      await Future.delayed(const Duration(milliseconds: 600));
      _controller.forward();
    }();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/map.png',
              fit: BoxFit.fill,
            ),
            SlideTransition(
              position: _offsetFloat,
              child: Image.asset('assets/navigation_pop.png'),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 88),
        child: MaterialButton(
          minWidth: 60,
          height: 60,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onPressed: () {},
          color: Colors.white,
          child: const Icon(
            Icons.gps_fixed,
            size: 28,
          ),
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: const Color(0x80333333),
            height: 32,
            alignment: Alignment.center,
            child: const Text(
              "경기도 성남시 분당구 정자동 102..",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "07:27 pm",
                    style: TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  RichText(
                    text: const TextSpan(
                        text: "2km",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff555555)),
                        children: [
                          TextSpan(
                              text: '남았습니다', style: TextStyle(fontSize: 18))
                        ]),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 100,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "안내종료",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
