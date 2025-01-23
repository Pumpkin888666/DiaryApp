import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:flutter/material.dart';

class LoadingState extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners(); // 通知所有监听者更新
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // 通知所有监听者更新
  }
}

class PumpkinPopup extends StatefulWidget {
  final bool whenHitBlack;
  final bool defaultLoading;
  final double defaultWidth;
  final double defaultHeight;
  final Widget? child;

  const PumpkinPopup(
      {super.key,
      this.whenHitBlack = true,
      this.defaultLoading = false,
      this.defaultWidth = 100,
      this.defaultHeight = 100,
      this.child});

  @override
  State<PumpkinPopup> createState() => PumpkinPopupState();
}

class PumpkinPopupState extends State<PumpkinPopup>
    with TickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late OverlayEntry _overlayMask;
  late bool _isShow = false;
  bool _isLoading = true;
  double width = 200;
  double height = 100;

  late AnimationController _sizeAnimationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late AnimationController _opacityAnimationController;
  late Animation<double> _opacityAnimation;

  int AnimatedTime = 200;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.defaultLoading;
    width = widget.defaultWidth;
    height = widget.defaultHeight;
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AnimatedTime), // 动画时长
    );
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AnimatedTime), // 动画时长
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _opacityAnimationController, curve: Curves.easeInOut),
    );
  }

  // 控制弹窗显示
  void show(BuildContext context) async {
    if (!_isShow) {
      setState(() {
        _isShow = true;
        _widthAnimation = Tween<double>(
                begin: _isLoading ? 0 : 200, end: _isLoading ? 200 : width)
            .animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );

        _heightAnimation = Tween<double>(
                begin: _isLoading ? 0 : 100, end: _isLoading ? 100 : height)
            .animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );
      });
      // 创建一个 OverlayEntry 并显示
      _overlayEntry = _createOverlayEntry(context);
      _overlayMask = _createOverlayMask(context);

      Overlay.of(context).insert(_overlayMask);
      Overlay.of(context).insert(_overlayEntry);

      _sizeAnimationController.forward(from: 0);
      _opacityAnimationController.forward(from: 0);
    }
  }

  // 控制弹窗关闭
  void hide() async {
    if (_isShow) {
      setState(() {
        _isShow = false;
        _widthAnimation = Tween<double>(
                begin: _isLoading ? 200 : width, end: _isLoading ? 0 : 200)
            .animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );

        _heightAnimation = Tween<double>(
                begin: _isLoading ? 100 : height, end: _isLoading ? 0 : 100)
            .animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );
      });
      _sizeAnimationController.forward(from: 0);
      _opacityAnimationController.reverse();
      await Future.delayed(Duration(milliseconds: AnimatedTime));

      _overlayEntry.remove();
      _overlayMask.remove();

    }
  }

  void auto(BuildContext context) {
    if (_isShow) {
      hide();
    } else {
      show(context);
    }
  }

  void handoffLoading(BuildContext context) {
    if (_isLoading) {
      setState(() {
        _isLoading = false;
        _isShow = false;
        _overlayEntry.remove();
        _overlayMask.remove();
        show(context);
      });
    } else {
      setState(() {
        _isLoading = true;
        _overlayEntry.remove();
        _overlayMask.remove();
        _widthAnimation = Tween<double>(begin: width, end: 200).animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );

        _heightAnimation = Tween<double>(begin: height, end: 100).animate(
          CurvedAnimation(
              parent: _sizeAnimationController, curve: Curves.easeInOut),
        );
        // 创建一个 OverlayEntry 并显示
        _overlayEntry = _createOverlayEntry(context);
        _overlayMask = _createOverlayMask(context);

        Overlay.of(context).insert(_overlayMask);
        Overlay.of(context).insert(_overlayEntry);

        _sizeAnimationController.forward(from: 0);
        _opacityAnimationController.forward(from: 0);
      });
    }
  }

  void changeSize(Size size) {
    setState(() {
      _widthAnimation = Tween<double>(begin: width, end: size.width).animate(
        CurvedAnimation(
            parent: _sizeAnimationController, curve: Curves.easeInOut),
      );

      _heightAnimation = Tween<double>(begin: height, end: size.height).animate(
        CurvedAnimation(
            parent: _sizeAnimationController, curve: Curves.easeInOut),
      );

      width = size.width;
      height = size.height;
    });
    _sizeAnimationController.forward(from: 0);
  }

  // 创建一个遮罩层，用于蒙黑背景并禁止点击
  OverlayEntry _createOverlayMask(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            if (widget.whenHitBlack) {
              hide();
            }
          },
          child: Material(
            color: Colors.black.withOpacity(0.1), // 半透明黑色遮罩层
            child: IgnorePointer(
              ignoring: false, // 如果为true则会忽略掉触摸事件
              child: Container(), // 空容器，利用遮罩阻止点击事件
            ),
          ),
        ),
      ),
    );
  }

  // 创建 OverlayEntry，用于显示弹窗
  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: Listenable.merge(
            [_sizeAnimationController, _opacityAnimationController]),
        builder: (context,  child) {
          return Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                _heightAnimation.value / 2, // 垂直居中
            left: MediaQuery.of(context).size.width / 2 -
                _widthAnimation.value / 2, // 水平居中
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _widthAnimation.value,
                  height: _heightAnimation.value,
                  decoration: BoxDecoration(
                    color: Colors.white, // 弹窗背景色
                    borderRadius: BorderRadius.circular(12), // 设置圆角
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFCCCCCC), // 阴影颜色
                        offset: Offset(2, 2), // 阴影偏移量
                        blurRadius: 12, // 阴影模糊度
                        spreadRadius: 2, // 阴影扩展范围
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const PumpkinLoading()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: _widthAnimation.value - 40,
                                  ),
                                  IconButton(
                                      onPressed: hide,
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: width,
                                  height: height,
                                  child: widget.child,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 空容器，不需要展示任何东西
  }
}
