import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_manifier_effect/home_controls.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ValueNotifier<double> _size;
  late ValueNotifier<double> _scale;
  late ValueNotifier<double> _rotation;

  @override
  void initState() {
    super.initState();
    _size = ValueNotifier(0);
    _scale = ValueNotifier(1.3);
    _rotation = ValueNotifier(0 * math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _size,
                  builder: (context, size, child) {
                    return ValueListenableBuilder(
                      valueListenable: _scale,
                      builder: (context, scale, child) {
                        return ValueListenableBuilder(
                          valueListenable: _rotation,
                          builder: (context, rotation, child) {
                            return ManifierEffect(
                              size: size,
                              scale: scale,
                              rotation: rotation,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              HomeControls(
                size: _size,
                scale: _scale,
                rotation: _rotation,
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
  late ValueNotifier<Offset> _positionOffset;

  late Matrix4 scaleMatrix;

  @override
  void initState() {
    super.initState();
    var screenWidth =
        (ui.window.physicalSize.shortestSide / ui.window.devicePixelRatio);
    var screenHeight =
        (ui.window.physicalSize.longestSide / ui.window.devicePixelRatio) - 250;
    _positionOffset = ValueNotifier(
      Offset(screenWidth / 2, screenHeight / 2),
    );
    scaleMatrix = Matrix4.identity()
      ..scale(widget.scale)
      ..translate(
          -(_positionOffset.value.dx / 8), -(_positionOffset.value.dy / 5));
  }

  void _updateMatrix() {
    scaleMatrix = Matrix4.identity()
      ..scale(widget.scale)
      ..translate(
          -(_positionOffset.value.dx - ((70 + widget.size / 2 / widget.scale))),
          -(_positionOffset.value.dy / 5));
    setState(() {});

    //8 and 5
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: 20,
          left: 0,
          right: 0,
          bottom: 50,
          child: Image.asset(
            'assets/image.png',
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCircle(
            center: Offset(_positionOffset.value.dx - widget.size,
                _positionOffset.value.dy - widget.size),
            radius: 70 + widget.size,
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ui.ImageFilter.matrix(scaleMatrix.storage),
              child: const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onPanUpdate: (details) {
              _positionOffset.value = details.globalPosition;
              _updateMatrix();
            },
            onPanStart: (details) {
              _positionOffset.value = details.globalPosition;
              _updateMatrix();
            },
            child: Transform.rotate(
              angle: widget.rotation,
              child: ValueListenableBuilder(
                valueListenable: _positionOffset,
                builder: (context, position, child) {
                  return CustomPaint(
                    painter: TextPainter(
                      position: position,
                      circleRadius: widget.size,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextPainter extends CustomPainter {
  TextPainter({
    required this.position,
    required this.circleRadius,
  });
  final Offset position;
  final double circleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size / 2;
    final mainPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final handlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      position,
      70 + circleRadius,
      mainPaint,
    );

    canvas.drawLine(
      Offset(position.dx, position.dy + 70 + circleRadius),
      Offset(position.dx, position.dy + 180 + circleRadius),
      handlePaint,
    );

    canvas.save();
    canvas.rotate(70 * math.pi / 180);
    canvas.restore();
  }

  @override
  bool shouldRepaint(TextPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TextPainter oldDelegate) => false;
}
