import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Química de Parejas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
    );
  }
}

// ============ PLAYER DATA ============
class Player {
  final String name;
  int score;

  Player({required this.name, this.score = 0});
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
              Color(0xFFFF6B35),
              Color(0xFFF7931E),
              Color(0xFFFFC107),
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
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/logofinalsinfondo1.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.favorite,
                                  size: 100,
                                  color: Color(0xFFFF6B35),
                                );
                              },
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
                      '🎮 Elijan una temática juntos',
                      style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '👥 Dos jugadores se turnan',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🙈 Uno se tapa los ojos',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🎡 El otro gira la ruleta',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '💬 Da una pista según la categoría',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🎯 El que adivinó arrastra el puntero',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '⭐ ¡Gana quien más puntos acumule!',
                      style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
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
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/logofinalsinfondo1.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.favorite,
                            size: 80,
                            color: Color(0xFFFF6B35),
                          );
                        },
                      ),
                    ),
                  ),
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
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

// ============ PLAYER SETUP SCREEN ============
class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({Key? key}) : super(key: key);

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '👫 Nombres de Jugadores',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _player1Controller,
                        decoration: InputDecoration(
                          labelText: '🎮 Jugador 1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _player2Controller,
                        decoration: InputDecoration(
                          labelText: '🎮 Jugador 2',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_player1Controller.text.trim().isEmpty ||
                          _player2Controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Por favor ingresa ambos nombres!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final player1 = Player(name: _player1Controller.text.trim());
                      final player2 = Player(name: _player2Controller.text.trim());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySetupScreen(
                            player1: player1,
                            player2: player2,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFC084FC),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

// ============ CATEGORY SETUP SCREEN ============
class CategorySetupScreen extends StatefulWidget {
  final Player player1;
  final Player player2;

  const CategorySetupScreen({
    Key? key,
    required this.player1,
    required this.player2,
  }) : super(key: key);

  @override
  State<CategorySetupScreen> createState() => _CategorySetupScreenState();
}

class _CategorySetupScreenState extends State<CategorySetupScreen> {
  final TextEditingController _customCategoryController = TextEditingController();
  String? selectedCategory;

  final List<String> predefinedCategories = [
    '🎬 Películas',
    '🍕 Comida',
    '🌍 Lugares',
    '💑 Parejas',
    '🎵 Música',
    '📚 Libros',
    '🎮 Videojuegos',
    '🏃 Deportes',
  ];

  @override
  void dispose() {
    _customCategoryController.dispose();
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  '🎯 Elige una Categoría',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // Categorías predefinidas
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: predefinedCategories.map((category) {
                    final isSelected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          _customCategoryController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFC084FC)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                const Text(
                  'O escribe tu propia categoría:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _customCategoryController,
                    decoration: InputDecoration(
                      labelText: '✏️ Tu categoría',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          selectedCategory = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final category = _customCategoryController.text.trim().isNotEmpty
                          ? _customCategoryController.text.trim()
                          : selectedCategory;

                      if (category == null || category.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Por favor elige o escribe una categoría!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuimicaParejas(
                            player1: widget.player1,
                            player2: widget.player2,
                            category: category,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFC084FC),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '¡Empezar a Jugar!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
  final Player player1;
  final Player player2;
  final String category;

  const QuimicaParejas({
    Key? key,
    required this.player1,
    required this.player2,
    required this.category,
  }) : super(key: key);

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
  int currentPlayerIndex = 0;
  bool musicEnabled = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _resultAnimationController;
  late Animation<double> _resultScaleAnimation;
  late Animation<double> _resultFadeAnimation;

  // Descomentar cuando tengas el paquete audioplayers:
  final AudioPlayer _spinPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();
  final AudioPlayer _bgMusicPlayer = AudioPlayer();

  final List<WheelSector> sectors = [
    WheelSector(value: 1, color: Colors.red, start: 70, end: 78),
    WheelSector(value: 3, color: Colors.blue, start: 78, end: 86),
    WheelSector(value: 5, color: Colors.orange, start: 86, end: 94),
    WheelSector(value: 3, color: Colors.blue, start: 94, end: 102),
    WheelSector(value: 1, color: Colors.red, start: 102, end: 110),
  ];

  Player get currentPlayer => currentPlayerIndex == 0 ? widget.player1 : widget.player2;

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
    // _spinPlayer.dispose();
    // _winPlayer.dispose();
    // _bgMusicPlayer.dispose();
    super.dispose();
  }

  void toggleMusic() {
    setState(() {
      musicEnabled = !musicEnabled;
    });
    if (musicEnabled) {
      _bgMusicPlayer.play(AssetSource('sounds/background.mp3'));
      _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      _bgMusicPlayer.stop();
    }
  }

  void spinWheel() {
    if (isSpinning) return;

    HapticFeedback.mediumImpact();
    _spinPlayer.play(AssetSource('sounds/spin.mp3'));

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
      // Detener el sonido de giro cuando la animación termina
      _spinPlayer.stop();
      
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

    // Actualizar puntuación
    currentPlayer.score += resultValue;

    setState(() {
      result = resultValue;
      isHidden = false;
      showConfetti = resultValue == 5;
    });

    _resultAnimationController.forward(from: 0);

    if (resultValue > 0) {
      _winPlayer.play(AssetSource('sounds/win.mp3'));
      if (resultValue == 5) {
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 100), () {
          HapticFeedback.heavyImpact();
        });
      }
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

  void nextTurn() {
    setState(() {
      currentPlayerIndex = currentPlayerIndex == 0 ? 1 : 0;
      result = null;
      showConfetti = false;
      wheelRotation = 0;
      pointerRotation = 90;
      isHidden = false;
    });
    _animationController.reset();
    _resultAnimationController.reset();
  }

  void showScoreboard() {
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
                '🏆 Puntuaciones',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.player1.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.player1.score.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.player1.score > widget.player2.score
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.player2.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.player2.score.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.player2.score > widget.player1.score
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ],
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
                  'Cerrar',
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
      body: result != null
          ? Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                if (showConfetti) const ConfettiWidget(),
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
                                  currentPlayer.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: nextTurn,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text(
                                        'Siguiente Turno',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: showScoreboard,
                                      icon: const Icon(Icons.emoji_events),
                                      iconSize: 32,
                                      color: Colors.amber,
                                    ),
                                  ],
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
                    // Header con info de jugador y música
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Turno de ${currentPlayer.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Categoría: ${widget.category}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: showScoreboard,
                                icon: const Icon(Icons.emoji_events),
                                color: Colors.amber,
                                iconSize: 28,
                              ),
                              IconButton(
                                onPressed: toggleMusic,
                                icon: Icon(
                                  musicEnabled ? Icons.music_note : Icons.music_off,
                                ),
                                color: Colors.white,
                                iconSize: 28,
                              ),
                            ],
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
                        child: Text(
                          '🎯 ${currentPlayer.name}, arrastra el puntero hacia donde crees que está el número',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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