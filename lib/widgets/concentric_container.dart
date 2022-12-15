import 'package:flutter/material.dart';

class ConcentricContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double pi = 3.14;
    final double percent = 2 * pi;
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 16.0;
    Offset radialPosition = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(radialPosition, size.width / 4, paint);

    Paint radialProgress = Paint();
    radialProgress.color = Colors.blueAccent;
    radialProgress.strokeCap = StrokeCap.round;
    radialProgress.style = PaintingStyle.stroke;
    radialProgress.strokeWidth = 30.0;

    Offset arcPosition = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: arcPosition, radius: size.width / 4),
        -pi / 2, percent, false, radialProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
