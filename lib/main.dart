import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Química de Parejas',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const QuimicaParejas(),
    );
  }
}

class QuimicaParejas extends StatefulWidget {
  const QuimicaParejas({Key? key}) : super(key: key);

  @override
  State<QuimicaParejas> createState() => _QuimicaParejasState();
}

class _QuimicaParejasState extends State<QuimicaParejas>
    with SingleTickerProviderStateMixin {
  double wheelRotation = 0;
  double pointerRotation = 90;
  bool isSpinning = false;
  bool isHidden = false;
  int? result;
  bool isDragging = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Sectores más gruesos: 8° cada uno (40° total en 180°)
  final List<WheelSector> sectors = [
    WheelSector(value: 1, color: Colors.red, start: 70, end: 78),
    WheelSector(value: 3, color: Colors.blue, start: 78, end: 86),
    WheelSector(value: 5, color: Colors.orange, start: 86, end: 94),
    WheelSector(value: 3, color: Colors.blue, start: 94, end: 102),
    WheelSector(value: 1, color: Colors.red, start: 102, end: 110),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void spinWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
      result = null;
      isHidden = false;
    });

    final random = math.Random();
    // Hacer muchas vueltas (5-8 vueltas completas)
    final randomSpin = 1800 + random.nextDouble() * 1080; // 5-8 vueltas
    // Posición final: SIEMPRE entre 70° y 110° (donde están los sectores, arriba del semicírculo)
    final finalPosition = 70 + random.nextDouble() * 40; // Solo en la zona de sectores
    final newRotation = wheelRotation + randomSpin + finalPosition;

    _animation = Tween<double>(
      begin: wheelRotation,
      end: newRotation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _animationController.forward(from: 0).then((_) {
      setState(() {
        wheelRotation = newRotation;
        isSpinning = false;
      });
    });
  }

  void hideWheel() {
    if (isSpinning) return;
    setState(() {
      isHidden = true;
    });
  }

  void verifyResult() {
    if (!isHidden || isSpinning) return;

    // Normalizar la rotación de la ruleta a 0-360°
    final normalizedWheel = ((wheelRotation % 360) + 360) % 360;
    
    // Calcular qué sector de la ruleta está bajo el puntero
    // pointerRotation va de 0 (derecha) a 180 (izquierda)
    // Los sectores están dibujados después de restar 90, entonces:
    // - sector original en 70-110° se dibuja efectivamente en -20 a 20° (o 340-20° en círculo completo)
    // Después de rotar la ruleta, estos sectores se mueven
    
    // Convertir pointerRotation al sistema de la ruleta
    // pointerRotation=0 (derecha) -> 0°
    // pointerRotation=90 (arriba) -> 90°
    // pointerRotation=180 (izquierda) -> 180°
    
    // Los sectores en el código usan un offset de -90, así que necesitamos compensar
    // Ángulo del puntero en el sistema de sectores
    final pointerInSectorSystem = pointerRotation + 90;
    
    // Restar la rotación de la ruleta para obtener qué parte original está bajo el puntero
    final sectorAngleUnderPointer = ((pointerInSectorSystem - normalizedWheel) % 360 + 360) % 360;
    
    // DEBUG: Ver los valores
    print('=== VERIFICACIÓN ===');
    print('Puntero visual: $pointerRotation°');
    print('Ruleta rotada: $normalizedWheel°');
    print('Puntero en sistema sectores: $pointerInSectorSystem°');
    print('Ángulo de sector bajo puntero: $sectorAngleUnderPointer°');
    
    // Buscar si esta posición coincide con algún sector original (70-110°)
    WheelSector? matchedSector;
    for (final sector in sectors) {
      if (sectorAngleUnderPointer >= sector.start && sectorAngleUnderPointer < sector.end) {
        matchedSector = sector;
        print('✓ Tocó sector original: ${sector.value} (${sector.start}-${sector.end}°)');
        break;
      }
    }
    
    // Si no encontró, buscar en sectores reflejados (250-290°)
    if (matchedSector == null) {
      for (final sector in sectors.reversed) {
        final reflectedStart = 360 - sector.end;
        final reflectedEnd = 360 - sector.start;
        
        if (sectorAngleUnderPointer >= reflectedStart && sectorAngleUnderPointer < reflectedEnd) {
          matchedSector = sector;
          print('✓ Tocó sector reflejado: ${sector.value} ($reflectedStart-$reflectedEnd°)');
          break;
        }
      }
    }
    
    if (matchedSector == null) {
      print('✗ No tocó ningún sector');
    }
    
    // Si no encuentra sector, devolver 0
    final resultValue = matchedSector?.value ?? 0;

    setState(() {
      result = resultValue;
      isHidden = false;
    });
  }

  void resetGame() {
    setState(() {
      wheelRotation = 0;
      pointerRotation = 90; // Esto lo deja apuntando arriba (Y)
      isHidden = false;
      result = null;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: result != null
          ? Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          result.toString(),
                          style: TextStyle(
                            fontSize: 96,
                            fontWeight: FontWeight.bold,
                            color: result == 5
                                ? Colors.amber
                                : result == 3
                                    ? Colors.blue
                                    : result == 1
                                        ? Colors.red
                                        : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result == 0 ? '¡Fallaste!' : '¡$result Puntos!',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              result = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF472B6),
                    Color(0xFFC084FC),
                    Color(0xFF818CF8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Text(
                            '💕 Química de Parejas',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ruleta Secreta',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Wheel Container - Con GestureDetector directo en la ruleta
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final currentRotation = isSpinning
                                  ? _animation.value
                                  : wheelRotation;
                              return WheelWidget(
                                wheelRotation: currentRotation,
                                pointerRotation: pointerRotation,
                                sectors: sectors,
                                isHidden: isHidden,
                                isDragging: isDragging,
                                onPointerUpdate: (angle) {
                                  if (isHidden && !isSpinning) {
                                    setState(() {
                                      pointerRotation = angle;
                                    });
                                  }
                                },
                                onDragStart: () {
                                  if (isHidden && !isSpinning) {
                                    setState(() {
                                      isDragging = true;
                                    });
                                  }
                                },
                                onDragEnd: () {
                                  setState(() {
                                    isDragging = false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Controls
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Girar Ruleta
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: (isSpinning || isHidden) ? null : spinWheel,
                              icon: const Icon(Icons.refresh),
                              label: Text(isSpinning ? 'Girando...' : 'Girar Ruleta'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Ocultar Ruleta
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: (isSpinning || isHidden) ? null : hideWheel,
                              icon: const Icon(Icons.visibility_off),
                              label: const Text('Ocultar Ruleta'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Verificar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: (!isHidden || isSpinning) ? null : verifyResult,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Verificar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Reiniciar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: resetGame,
                              icon: const Icon(Icons.restart_alt),
                              label: const Text('Reiniciar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Instructions
                    if (isHidden)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🎯 Arrastra el puntero rojo hacia donde crees que está el número',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class WheelSector {
  final int value;
  final Color color;
  final double start;
  final double end;

  WheelSector({
    required this.value,
    required this.color,
    required this.start,
    required this.end,
  });
}

class WheelWidget extends StatelessWidget {
  final double wheelRotation;
  final double pointerRotation;
  final List<WheelSector> sectors;
  final bool isHidden;
  final bool isDragging;
  final Function(double)? onPointerUpdate;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  const WheelWidget({
    Key? key,
    required this.wheelRotation,
    required this.pointerRotation,
    required this.sectors,
    required this.isHidden,
    required this.isDragging,
    this.onPointerUpdate,
    this.onDragStart,
    this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        onDragStart?.call();
      },
      onPanUpdate: (details) {
        if (!isHidden) return;
        
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        
        // Centro del semicírculo
        final centerX = 150.0;
        final centerY = 150.0;
        
        // Vector desde el centro hacia el toque
        final dx = localPosition.dx - centerX;
        final dy = localPosition.dy - centerY;
        
        // Calcular ángulo usando atan2
        double angleRad = math.atan2(-dy, dx);
        double angleDeg = angleRad * (180 / math.pi);
        
        // Convertir rangos negativos
        if (angleDeg < 0) {
          angleDeg = 360 + angleDeg;
        }
        
        // Limitar al semicírculo superior
        if (angleDeg > 180 && angleDeg <= 270) {
          angleDeg = 180;
        } else if (angleDeg > 270) {
          angleDeg = 0;
        }
        
        // INVERTIR para que siga el dedo correctamente
        // 0° se convierte en 180° y viceversa
        angleDeg = 180 - angleDeg;
        
        // Clamp final
        angleDeg = angleDeg.clamp(0.0, 180.0);
        
        onPointerUpdate?.call(angleDeg);
      },
      onPanEnd: (details) {
        onDragEnd?.call();
      },
      child: SizedBox(
        width: 300,
        height: 170,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Marcador "0" - Ahora dentro de la pantalla
            Positioned(
              left: -55,
              bottom: 10,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            // Marcador "100" - Ahora dentro de la pantalla
            Positioned(
              right: -55,
              bottom: 10,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '100',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            // Wheel con ClipPath para ocultar triángulos fuera del semicírculo
            ClipPath(
              clipper: SemicircleClipper(),
              child: CustomPaint(
                size: const Size(300, 150),
                painter: WheelPainter(
                  wheelRotation: wheelRotation,
                  sectors: sectors,
                  isHidden: isHidden,
                ),
              ),
            ),

            // Pointer - Solo visible en el semicírculo
            if (pointerRotation >= 0 && pointerRotation <= 180)
              Transform.rotate(
                angle: -(90 - pointerRotation) * math.pi / 180,
                alignment: Alignment.bottomCenter,
                child: CustomPaint(
                  size: const Size(300, 150),
                  painter: PointerPainter(
                    isDragging: isDragging,
                    isHidden: isHidden,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Clipper para crear la máscara del semicírculo
class SemicircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    
    path.moveTo(0, size.height);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
    );
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WheelPainter extends CustomPainter {
  final double wheelRotation;
  final List<WheelSector> sectors;
  final bool isHidden;

  WheelPainter({
    required this.wheelRotation,
    required this.sectors,
    required this.isHidden,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Dibujar semicírculo de fondo
    final bgPaint = Paint()
      ..color = isHidden ? Colors.grey[600]! : Colors.white
      ..style = PaintingStyle.fill;

    final bgPath = Path()
      ..moveTo(0, size.height)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi,
        false,
      )
      ..close();

    canvas.drawPath(bgPath, bgPaint);

    // Dibujar borde
    final borderPaint = Paint()
      ..color = isHidden ? Colors.grey[700]! : Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(bgPath, borderPaint);

    // Dibujar sectores si no está oculto
    if (!isHidden) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(wheelRotation * math.pi / 180);

      for (final sector in sectors) {
        final sectorPaint = Paint()
          ..color = sector.color
          ..style = PaintingStyle.fill;

        final startAngle = (sector.start - 90) * math.pi / 180;
        final sweepAngle = (sector.end - sector.start) * math.pi / 180;

        final path = Path()
          ..moveTo(0, 0)
          ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: radius),
            startAngle,
            sweepAngle,
            false,
          )
          ..close();

        canvas.drawPath(path, sectorPaint);

        // Dibujar borde del sector
        final sectorBorderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawPath(path, sectorBorderPaint);

        // Dibujar número más pequeño
        final midAngle = (sector.start + sector.end) / 2 - 90;
        final textX = (radius * 0.64) * math.cos(midAngle * math.pi / 180);
        final textY = (radius * 0.64) * math.sin(midAngle * math.pi / 180);

        final textPainter = TextPainter(
          text: TextSpan(
            text: sector.value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Reducido de 20 a 16
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
        );
      }

      // DIBUJAR LA PARTE REFLEJADA (del otro lado del semicírculo)
      // Crear sectores reflejados: si del lado derecho sale (3,1), del izquierdo sale (1,3)
      for (final sector in sectors.reversed) {
        final sectorPaint = Paint()
          ..color = sector.color
          ..style = PaintingStyle.fill;

        // Reflejar: convertir 70-110° a 250-290° (lado opuesto)
        final reflectedStart = 360 - sector.end;
        final reflectedEnd = 360 - sector.start;
        
        final startAngle = (reflectedStart - 90) * math.pi / 180;
        final sweepAngle = (reflectedEnd - reflectedStart) * math.pi / 180;

        final path = Path()
          ..moveTo(0, 0)
          ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: radius),
            startAngle,
            sweepAngle,
            false,
          )
          ..close();

        canvas.drawPath(path, sectorPaint);

        // Dibujar borde del sector reflejado
        final sectorBorderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawPath(path, sectorBorderPaint);

        // Dibujar número reflejado
        final midAngle = ((reflectedStart + reflectedEnd) / 2 - 90) * math.pi / 180;
        final textX = (radius * 0.64) * math.cos(midAngle);
        final textY = (radius * 0.64) * math.sin(midAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: sector.value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
        );
      }

      canvas.restore();
    }

    // Dibujar centro
    final centerPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, centerPaint);

    final centerBorderPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, 25, centerBorderPaint);
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) {
    return wheelRotation != oldDelegate.wheelRotation ||
        isHidden != oldDelegate.isHidden;
  }
}

class PointerPainter extends CustomPainter {
  final bool isDragging;
  final bool isHidden;

  PointerPainter({
    required this.isDragging,
    required this.isHidden,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    final pointerPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final pointerPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - 3, center.dy - 115)
      ..lineTo(center.dx, center.dy - 125)
      ..lineTo(center.dx + 3, center.dy - 115)
      ..close();

    canvas.drawPath(pointerPath, pointerPaint);

    // Borde del puntero
    final pointerBorderPaint = Paint()
      ..color = const Color(0xFF991B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(pointerPath, pointerBorderPaint);

    // Círculo en la base
    canvas.drawCircle(center, 10, pointerPaint);
    canvas.drawCircle(center, 10, pointerBorderPaint);
  }

  @override
  bool shouldRepaint(PointerPainter oldDelegate) {
    return isDragging != oldDelegate.isDragging;
  }
}