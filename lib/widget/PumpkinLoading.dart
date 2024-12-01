import 'package:flutter/material.dart';
import 'dart:math';

class PumpkinLoading extends StatefulWidget {
  final Color color;
  final Size size;
  const PumpkinLoading({super.key,this.color = Colors.grey,this.size = const Size(20, 20)});

  @override
  _PumpkinLoadingState createState() => _PumpkinLoadingState();
}

class _PumpkinLoadingState extends State<PumpkinLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: PumpkinLoadingPainter(_animation,widget.color,widget.size),
    );
  }
}

class PumpkinLoadingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final Size size;

  PumpkinLoadingPainter(this.animation, this.color,this.size) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 10;

    // 计算缺口的角度
    double angleOffset = animation.value * 5 * pi; // 控制旋转的角度

    // 画加载圆环（有两个对称缺口的部分）
    double sweepAngle = pi / 1.8; // 每个缺口占的角度

    // 第一个缺口（从上方开始偏移 -pi/3）
    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        -pi / 3 + angleOffset, // 第一个缺口的起始角度
        sweepAngle,
        false,
        paint
    );

    // 第二个缺口（与第一个缺口对称，偏移pi）
    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        pi + (-pi / 3) + angleOffset, // 第二个缺口的起始角度，偏移pi使其对称
        sweepAngle,
        false,
        paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 每次动画更新时重绘
  }
}
