import 'package:diaryapp/widget/PumpkinImage.dart';
import 'package:flutter/material.dart';

class PumpkinConfirm extends StatefulWidget {
  final bool cancel;
  final Widget child;

  final String url;
  final BoxDecoration? decoration;
  final bool isNetworkImage;
  final double height;
  final double? i_height;
  final BoxFit fit;
  final double width;

  const PumpkinConfirm({
    super.key,
    this.cancel = true,
    required this.child,
    required this.url,
    this.decoration,
    required this.isNetworkImage,
    required this.height,
    this.i_height,
    required this.fit,
    required this.width,
  });

  @override
  State<PumpkinConfirm> createState() => PumpkinConfirmState();
}

class PumpkinConfirmState extends State<PumpkinConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: widget.width,
            child: Column(
              children: [
                PumpkinImage(
                  url: widget.url,
                  isNetworkImage: widget.isNetworkImage,
                  height: widget.height,
                  decoration: widget.decoration,
                  fit: widget.fit,
                  width: widget.width,
                  i_height: widget.i_height,
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
