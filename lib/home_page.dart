import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_manifier_effect/home_controls.dart';

import 'app_constants.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = useState(AppConstants.minSize);
    final scale = useState(AppConstants.minScale);
    final rotation = useState(30 * math.pi / 180);
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ManifierEffect(
                  size: size.value,
                  scale: scale.value,
                  rotation: rotation.value,
                ),
              ),
              HomeControls(
                size: size,
                scale: scale,
                rotation: rotation,
              ),
            ],
          )),
    );
  }
}

class ManifierEffect extends StatefulWidget {
  const ManifierEffect({
    Key? key,
    required this.size,
    required this.scale,
    required this.rotation,
  }) : super(key: key);

  final double size;
  final double scale;
  final double rotation;

  @override
  State<ManifierEffect> createState() => _ManifierEffectState();
}

class _ManifierEffectState extends State<ManifierEffect> {
  late Offset _positionOffset;

  @override
  void initState() {
    super.initState();
    var screenWidth =
        (ui.window.physicalSize.shortestSide / ui.window.devicePixelRatio);
    var screenHeight =
        (ui.window.physicalSize.longestSide / ui.window.devicePixelRatio) - 250;
    _positionOffset = Offset(screenWidth / 2, screenHeight / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          bottom: 20,
          child: GestureDetector(
            onPanUpdate: (details) {
              _positionOffset = details.globalPosition;
              setState(() {});
            },
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: _positionOffset.dy - (widget.size / 2),
          left: _positionOffset.dx - (widget.size / 2),
          child: RawMagnifier(
            magnificationScale: widget.scale,
            decoration: const MagnifierDecoration(
              shape: CircleBorder(),
            ),
            size: Size(widget.size, widget.size),
          ),
        ),
        Positioned(
          top: _positionOffset.dy,
          left: _positionOffset.dx,
          child: Transform(
            transform: Matrix4.identity()
              ..rotateZ(widget.rotation)
              ..translate(
                -(widget.size / 2),
                -(widget.size / 2),
              ),
            child: CustomPaint(
              painter: ManifierPainter(
                frameSize: (widget.size / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ManifierPainter extends CustomPainter {
  ManifierPainter({
    required this.frameSize,
  });
  final double frameSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size / 2;
    final mainPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke;

    final handlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(
        center.width + frameSize,
        center.height + frameSize,
      ),
      frameSize,
      mainPaint,
    );

    canvas.drawLine(
      Offset(center.width + frameSize, center.height + (frameSize * 2)),
      Offset(center.width + frameSize, center.height + ((frameSize * 3.2))),
      handlePaint,
    );
  }

  @override
  bool shouldRepaint(ManifierPainter oldDelegate) => true;
}
