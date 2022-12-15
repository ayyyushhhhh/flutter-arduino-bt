import 'package:flutter/material.dart';

class TemperaturePainter extends CustomPainter {
  final double sensorTemp;
  final double extremeTemp;

  TemperaturePainter({required this.sensorTemp, required this.extremeTemp});

  Color _getcolor(double temp) {
    if (sensorTemp < 20) {
      return Colors.lightBlue;
    } else if (sensorTemp > 20 && sensorTemp < 25) {
      return Colors.blueAccent;
    } else if (sensorTemp > 25 && sensorTemp < 35) {
      return Colors.orangeAccent;
    }
    return Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double pi = 3.14;
    final double percent = (sensorTemp / extremeTemp) * 2 * pi;

    Paint paint = Paint();

    paint.color = Colors.grey;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 16.0;
    Offset radialPosition = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(radialPosition, size.width / 4, paint);

    Paint radialProgress = Paint();
    radialProgress.color = _getcolor(sensorTemp);
    radialProgress.strokeCap = StrokeCap.butt;
    radialProgress.style = PaintingStyle.stroke;
    radialProgress.strokeWidth = 16.0;

    Offset arcPosition = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: arcPosition, radius: size.width / 4),
        -pi / 2, percent, false, radialProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
