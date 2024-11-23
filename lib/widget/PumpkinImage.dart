import 'package:flutter/material.dart';

class PumpkinImage extends StatefulWidget {
  final String? url;

  const PumpkinImage({super.key, required this.url});

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
      duration: const Duration(milliseconds: 1000),
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
            height: MediaQuery.of(context).size.height,
            child: AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft, // 左端固定
                    widthFactor: _widthAnimation.value, // 动态调整宽度
                    child: Image.network(
                      widget.url!,
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height,
                    ), // 替换为你的图片路径
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
