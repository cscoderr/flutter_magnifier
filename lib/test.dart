import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ValueNotifier<Offset> _positionOffset;
  late ValueNotifier<double> _size;
  late ValueNotifier<double> _scale;
  late Matrix4 scaleMatrix;

  @override
  void initState() {
    super.initState();
    _positionOffset = ValueNotifier(const Offset(150, 150));
    _size = ValueNotifier(0);
    _scale = ValueNotifier(1.2);
    final transalateX =
        _positionOffset.value.dx - (_size.value / 2 / _scale.value);
    final transalateY =
        _positionOffset.value.dy - (_size.value / 2 / _scale.value);
    scaleMatrix = Matrix4.identity()
      ..scale(_scale.value, _scale.value)
      ..translate(-transalateX, -transalateY);
  }

  void _updateMatrix() {
    print(_positionOffset.value.dy);
    scaleMatrix = Matrix4.identity()
      ..scale(_scale.value, _scale.value)
      ..translate(
          -(_positionOffset.value.dx - 70), -(_positionOffset.value.dy - 70));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/image.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCircle(
                center: _positionOffset.value,
                radius: 70 + _size.value,
              ),
              child: GestureDetector(
                onPanUpdate: (event) {
                  final box = context.findRenderObject() as RenderBox;
                  _positionOffset.value = event.globalPosition;
                  _updateMatrix();
                },
                onPanStart: (event) {
                  final box = context.findRenderObject() as RenderBox;
                  _positionOffset.value = event.globalPosition;
                  _updateMatrix();
                },
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.matrix(scaleMatrix.storage),
                    child: const SizedBox.shrink(),
                  ),
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
                child: ValueListenableBuilder(
                  valueListenable: _positionOffset,
                  builder: (context, position, child) {
                    return CustomPaint(
                      painter: TextPainter(
                        position: position,
                        circleRadius: _size.value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManifierPainter extends CustomPainter {
  ManifierPainter({
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
      Offset(center.width, center.height),
      70 + circleRadius,
      mainPaint,
    );

    canvas.drawLine(
      Offset(center.width, center.height + circleRadius),
      Offset(center.width + circleRadius, center.height - 170 + circleRadius),
      handlePaint,
    );
  }

  @override
  bool shouldRepaint(ManifierPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ManifierPainter oldDelegate) => false;
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
  }

  @override
  bool shouldRepaint(TextPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TextPainter oldDelegate) => false;
}
