import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import '../palette.dart';

class BackgroundPainter extends CustomPainter{

  BackgroundPainter({Animation<double> animation}) :
      darkGreenPaint = Paint()..color = Palette.darkGreen..style = PaintingStyle.fill,
      greenPaint = Paint()..color = Palette.blue..style = PaintingStyle.fill,
      goldPaint = Paint()..color = Palette.gold..style = PaintingStyle.fill,
      linePaint = Paint()..color = Palette.lightGreen..style = PaintingStyle.stroke..strokeWidth = 4,
      liquidAnim = CurvedAnimation(
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInBack,
        parent: animation,
      ),
      goldAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(0, 0.7, curve: Interval(0, 0.8, curve: SpringCurve()),),
        reverseCurve: Curves.linear,
      ),
      greenAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(0, 0.8, curve: Interval(0, 0.9, curve: SpringCurve()),),
        reverseCurve: Curves.easeInCirc,
      ),
      darkGreenAnim = CurvedAnimation(
          parent: animation,
          curve: const SpringCurve(),
          reverseCurve: Curves.easeInCirc
      ),
      super(repaint: animation);

  final Animation<double> liquidAnim;
  final Animation<double> darkGreenAnim;
  final Animation<double> greenAnim;
  final Animation<double> goldAnim;

  final Paint linePaint;
  final Paint darkGreenPaint;
  final Paint greenPaint;
  final Paint goldPaint;

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need three or more points to create a path.');
    }
    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }
    // connect the last two points
    path.quadraticBezierTo(
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintDarkGreen(canvas, size);

    paintGreen(size, canvas);

    paintGold(size, canvas);
  }

  void paintDarkGreen(Canvas canvas, Size size){
    final path = Path();
    path.moveTo(size.width, size.height/2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(0, size.height, darkGreenAnim.value),
    );
    _addPointsToPath(path, [
      Point(
        lerpDouble(0, size.width/3, darkGreenAnim.value),
        lerpDouble(0, size.height, darkGreenAnim.value),
      ),
      Point(
        lerpDouble(size.width/2, size.width/4 * 3, liquidAnim.value),
        lerpDouble(size.height/2, size.height/4 * 3, liquidAnim.value),
      ),
      Point(
        size.width,
        lerpDouble(size.height/2, size.height*3/4, liquidAnim.value),
      ),
    ]);
    
    canvas.drawPath(path, darkGreenPaint);
  }

  void paintGreen(Size size, Canvas canvas) {
    final path = Path();
    path.moveTo(size.width, 300);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(
        size.height / 4,
        size.height / 2,
        greenAnim.value,
      ),
    );
    _addPointsToPath(
      path,
      [
        Point(
          size.width / 4,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 5,
          lerpDouble(size.height / 4, size.height / 2, liquidAnim.value),
        ),
        Point(
          size.width * 4 / 5,
          lerpDouble(size.height / 6, size.height / 3, greenAnim.value),
        ),
        Point(
          size.width,
          lerpDouble(size.height / 5, size.height / 4, greenAnim.value),
        ),
      ],
    );
    canvas.drawPath(path, greenPaint);
  }

  void paintGold(Size size, Canvas canvas) {
    if (goldAnim.value > 0) {
      final path = Path();

      path.moveTo(size.width * 3 / 4, 0);
      path.lineTo(0, 0);
      path.lineTo(
        0,
        lerpDouble(0, size.height / 12, goldAnim.value),
      );

      _addPointsToPath(path, [
        Point(
          size.width / 7,
          lerpDouble(0, size.height / 6, liquidAnim.value),
        ),
        Point(
          size.width / 3,
          lerpDouble(0, size.height / 10, liquidAnim.value),
        ),
        Point(
          size.width / 3 * 2,
          lerpDouble(0, size.height / 8, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 4,
          0,
        ),
      ]);
      canvas.drawPath(path, goldPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}

class Point{
  final double x;
  final double y;

  Point(this.x, this.y);
}

// Custom curve to give gooey spring effect
class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}