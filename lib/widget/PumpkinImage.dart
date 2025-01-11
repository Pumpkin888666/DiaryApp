import 'package:flutter/material.dart';

class PumpkinImage extends StatefulWidget {
  final String url;
  final BoxDecoration? decoration;
  final bool isNetworkImage;
  final double height;
  final double? i_height;
  final BoxFit fit;
  final double width;

  const PumpkinImage(
      {super.key,
      required this.url,
      this.decoration,
      this.isNetworkImage = true,
      required this.height,
      this.fit = BoxFit.fill,
      this.width = 300,
      this.i_height});

  @override
  _PumpkinImageState createState() => _PumpkinImageState();
}

class _PumpkinImageState extends State<PumpkinImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();

    // 创建动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 定义宽度的动画，范围从0到1
    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    // 启动动画
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: widget.decoration,
            height: widget.height,
            child: AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _widthAnimation.value,
                    child: widget.isNetworkImage
                        ? Image.network(
                            widget.url,
                            fit: widget.fit,
                            height: widget.i_height,
                            width: widget.width,
                          )
                        : Image.asset(
                            widget.url,
                            fit: widget.fit,
                            width: widget.width,
                            height: widget.i_height,
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 在组件销毁时释放控制器
    super.dispose();
  }
}
