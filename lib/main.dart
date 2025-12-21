import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const SplashScreen(),
    );
  }
}

// ============ SPLASH SCREEN ============
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Navegar al menú después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Texto Villa primero
                      const Text(
                        'Villa',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Logo
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/logofinalsinfondo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Presenta',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '💕 Química de Parejas',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============ MENU SCREEN ============
class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFF472B6), Color(0xFFC084FC)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Cómo se juega?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '🎮 Se empieza eligiendo una temática',
                      style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '👥 Se necesitan dos jugadores',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🙈 Uno de los jugadores se tapa los ojos',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🎡 El otro jugador gira la ruleta',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '👻 Al terminar de girar, se oculta la ruleta',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '💬 El jugador que giró la ruleta da una palabra de pista según la temática',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🎯 El jugador que se tapó los ojos arrastra el puntero rojo hacia donde cree que están los puntos',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '⭐ El objetivo es sacar la mayor puntuación adivinando correctamente',
                      style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 8),
                    Text(
                      '🏆 PUNTUACIÓN:',
                      style: TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '🔥 Toca el 5 = 5 puntos\n💙 Toca el 3 = 3 puntos\n❤️ Toca el 1 = 1 punto\n😢 No tocar nada = 0 puntos',
                      style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFC084FC),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  '💕 Química de Parejas',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ruleta Secreta',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 60),
                // Botón Jugar
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuimicaParejas()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFC084FC),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                  ),
                  child: const Text(
                    'Jugar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón Cómo se juega
                OutlinedButton(
                  onPressed: () => _showInstructions(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '¿Cómo se juega?',
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
      ),
    );
  }
}

// ============ GAME SCREEN ============
class QuimicaParejas extends StatefulWidget {
  const QuimicaParejas({Key? key}) : super(key: key);

  @override
  State<QuimicaParejas> createState() => _QuimicaParejasState();
}

class _QuimicaParejasState extends State<QuimicaParejas>
    with TickerProviderStateMixin {
  double wheelRotation = 0;
  double pointerRotation = 90;
  bool isSpinning = false;
  bool isHidden = false;
  int? result;
  bool isDragging = false;
  bool showConfetti = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _resultAnimationController;
  late Animation<double> _resultScaleAnimation;
  late Animation<double> _resultFadeAnimation;

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

    _resultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _resultFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void spinWheel() {
    if (isSpinning) return;

    HapticFeedback.mediumImpact();

    setState(() {
      isSpinning = true;
      result = null;
      isHidden = false;
      showConfetti = false;
    });

    final random = math.Random();
    final randomSpin = 1800 + random.nextDouble() * 1080;
    final finalPosition = 70 + random.nextDouble() * 40;
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
      HapticFeedback.lightImpact();
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

    HapticFeedback.heavyImpact();

    final normalizedWheel = ((wheelRotation % 360) + 360) % 360;
    final pointerInSectorSystem = pointerRotation + 90;
    final sectorAngleUnderPointer = ((pointerInSectorSystem - normalizedWheel) % 360 + 360) % 360;
    
    WheelSector? matchedSector;
    for (final sector in sectors) {
      if (sectorAngleUnderPointer >= sector.start && sectorAngleUnderPointer < sector.end) {
        matchedSector = sector;
        break;
      }
    }
    
    if (matchedSector == null) {
      for (final sector in sectors.reversed) {
        final reflectedStart = 360 - sector.end;
        final reflectedEnd = 360 - sector.start;
        
        if (sectorAngleUnderPointer >= reflectedStart && sectorAngleUnderPointer < reflectedEnd) {
          matchedSector = sector;
          break;
        }
      }
    }
    
    final resultValue = matchedSector?.value ?? 0;

    setState(() {
      result = resultValue;
      isHidden = false;
      showConfetti = resultValue == 5;
    });

    _resultAnimationController.forward(from: 0);

    if (resultValue == 5) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 100), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  void resetGame() {
    setState(() {
      wheelRotation = 0;
      pointerRotation = 90;
      isHidden = false;
      result = null;
      showConfetti = false;
    });
    _animationController.reset();
    _resultAnimationController.reset();
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
                // Confetti
                if (showConfetti) const ConfettiWidget(),
                // Resultado
                Center(
                  child: AnimatedBuilder(
                    animation: _resultAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _resultFadeAnimation,
                        child: ScaleTransition(
                          scale: _resultScaleAnimation,
                          child: Container(
                            margin: const EdgeInsets.all(32),
                            padding: const EdgeInsets.all(48),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
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
                                      showConfetti = false;
                                    });
                                    _resultAnimationController.reset();
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
                      );
                    },
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
                                    HapticFeedback.selectionClick();
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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

// ============ CONFETTI WIDGET ============
class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({Key? key}) : super(key: key);

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      particles.add(ConfettiParticle(
        x: random.nextDouble(),
        y: -0.1,
        color: Color.fromRGBO(
          random.nextInt(255),
          random.nextInt(255),
          random.nextInt(255),
          1,
        ),
        speed: 0.3 + random.nextDouble() * 0.5,
        rotation: random.nextDouble() * math.pi * 2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ConfettiPainter(particles, _controller.value),
        );
      },
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  Color color;
  double speed;
  double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.speed,
    required this.rotation,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final y = particle.y + progress * particle.speed;
      if (y > 1.1) continue;

      final paint = Paint()..color = particle.color;
      final rect = Rect.fromCenter(
        center: Offset(particle.x * size.width, y * size.height),
        width: 8,
        height: 12,
      );

      canvas.save();
      canvas.translate(particle.x * size.width, y * size.height);
      canvas.rotate(particle.rotation + progress * math.pi * 4);
      canvas.translate(-particle.x * size.width, -y * size.height);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

// ============ WHEEL CLASSES ============
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
        
        final centerX = 150.0;
        final centerY = 150.0;
        
        final dx = localPosition.dx - centerX;
        final dy = localPosition.dy - centerY;
        
        double angleRad = math.atan2(-dy, dx);
        double angleDeg = angleRad * (180 / math.pi);
        
        if (angleDeg < 0) {
          angleDeg = 360 + angleDeg;
        }
        
        if (angleDeg > 180 && angleDeg <= 270) {
          angleDeg = 180;
        } else if (angleDeg > 270) {
          angleDeg = 0;
        }
        
        angleDeg = 180 - angleDeg;
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

    final borderPaint = Paint()
      ..color = isHidden ? Colors.grey[700]! : Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(bgPath, borderPaint);

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

        final sectorBorderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawPath(path, sectorBorderPaint);

        final midAngle = (sector.start + sector.end) / 2 - 90;
        final textX = (radius * 0.64) * math.cos(midAngle * math.pi / 180);
        final textY = (radius * 0.64) * math.sin(midAngle * math.pi / 180);

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

      for (final sector in sectors.reversed) {
        final sectorPaint = Paint()
          ..color = sector.color
          ..style = PaintingStyle.fill;

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

        final sectorBorderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawPath(path, sectorBorderPaint);

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

    // Efecto de brillo cuando está arrastrando
    if (isDragging) {
      final glowPaint = Paint()
        ..color = const Color(0xFFDC2626).withOpacity(0.5)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final glowPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx - 6, center.dy - 115)
        ..lineTo(center.dx, center.dy - 135)
        ..lineTo(center.dx + 6, center.dy - 115)
        ..close();

      canvas.drawPath(glowPath, glowPaint);
    }

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

    final pointerBorderPaint = Paint()
      ..color = const Color(0xFF991B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(pointerPath, pointerBorderPaint);

    canvas.drawCircle(center, 10, pointerPaint);
    canvas.drawCircle(center, 10, pointerBorderPaint);
  }

  @override
  bool shouldRepaint(PointerPainter oldDelegate) {
    return isDragging != oldDelegate.isDragging;
  }
}